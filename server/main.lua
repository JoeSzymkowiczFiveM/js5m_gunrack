local ox_inventory = exports.ox_inventory
local db = require 'server.db.mysql'
Racks = {}
RacksLoaded = false

local function getWeaponSlot(rack, weaponName)
    local weaponType = Config.rackableWeapons[weaponName].weaponType
    if not weaponType then return false end
    for i=1, 5 do
        if not Racks[rack][weaponType][i] or Racks[rack][weaponType][i].available then
            return i
        end
    end
    return false
end

local function inDistanceOfGunRack(id, src)
    if not Racks[id] then return false end

    local ped = GetPlayerPed(src)
    if ped == 0 then return false end

    if #(GetEntityCoords(ped) - vec3(Racks[id].coords.x, Racks[id].coords.y, Racks[id].coords.z)) < 6 then
        return true
    end
    return false
end

RegisterServerEvent('js5m_gunrack:server:placeGunRack', function(coords, rot, code)
    local src = source
    local ped = GetPlayerPed(src)
    local sourceCoords = GetEntityCoords(ped)
    if #(sourceCoords - coords) > 5 then return end

    if ox_inventory:RemoveItem(src, 'gunrack', 1) then
        local rackData = {
            coords = {x = coords.x, y = coords.y, z = coords.z, w = rot},
            rifles = {},
            pistols = {},
            code = code,
            taser = false,
        }
        local insertedId = db.createGunRack(rackData)
        Racks[insertedId] = rackData
        TriggerClientEvent('js5m_gunrack:client:placeGunRack', -1, insertedId, rackData)
    end
end)

RegisterServerEvent('js5m_gunrack:server:storeWeapon', function(rackIndex, weaponSlot, weaponName)
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    while Racks[rackIndex].busy do Wait(10) end
    Racks[rackIndex].busy = true
    if not Config.rackableWeapons[weaponName] then return end
    local weaponType = Config.rackableWeapons[weaponName].weaponType
    local rackSlot = getWeaponSlot(rackIndex, weaponName)
    if rackSlot then
        local slot = exports.ox_inventory:GetSlot(src, weaponSlot)
        if slot.name ~= weaponName then return end
        if ox_inventory:RemoveItem(src, weaponName, 1, nil, weaponSlot) then
            local rackInfo = Racks[rackIndex]
            local data = {
                name = weaponName,
                available = false,
                metadata = slot.metadata
            }
            rackInfo[weaponType][rackSlot] = data
            db.saveGunRack(rackIndex, rackInfo, weaponType)
            TriggerClientEvent('js5m_gunrack:client:storeWeapon', -1, rackIndex, rackSlot, weaponType, data)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                description = 'Weird, you don\'t have that weapon',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'No more slots of that type left',
            type = 'error'
        })
    end
    Racks[rackIndex].busy = false
end)

RegisterServerEvent('js5m_gunrack:server:takeWeapon', function(rackIndex, rackSlot, weaponName)
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    while Racks[rackIndex].busy do Wait(10) end
    Racks[rackIndex].busy = true
    local weaponType = Config.rackableWeapons[weaponName].weaponType
    if Racks[rackIndex][weaponType][rackSlot].name == weaponName then
        if ox_inventory:AddItem(src, weaponName, 1, Racks[rackIndex][weaponType][rackSlot].metadata) then
            local rackInfo = Racks[rackIndex]
            rackInfo[weaponType][rackSlot] = {name = nil, available = true}
            db.saveGunRack(rackIndex, rackInfo, weaponType)
            TriggerClientEvent('js5m_gunrack:client:takeWeapon', -1, rackIndex, rackSlot, weaponType)
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            description = 'That weapon does not seem to be in this rack',
            type = 'error'
        })
    end
    Racks[rackIndex].busy = false
end)

RegisterServerEvent('js5m_gunrack:server:destroyGunRack', function(rackIndex)
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    if not Racks[rackIndex] then return end
    Racks[rackIndex] = nil
    db.deleteGunRack(rackIndex)
    TriggerClientEvent('js5m_gunrack:client:destroyGunRack', -1, rackIndex)
end)

lib.callback.register('js5m_gunrack:server:getRacks', function(source)
    while not RacksLoaded do Wait(10) end
    return Racks
end)