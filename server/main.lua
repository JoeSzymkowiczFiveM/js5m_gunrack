local ox_inventory = exports.ox_inventory
-- local db = require 'server.db.kvp'
-- local Racks = db.getAllGunRacks()

local Racks = {}

MySQL.ready(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM gunracks")
    for k, v in pairs(result) do        
        Racks[v.id] = {
            coords = json.decode(v.coords),
            rifles = json.decode(v.rifles),
            taser = v.taser == 1 and true or false
        }
    end
    print("Gun Racks Loaded")
end)



local function getRifleSlot(rack)
    for i=1, 5 do
        if not Racks[rack].rifles[i] or Racks[rack].rifles[i].available then
            return i
        end
    end
    return false
end

local function inDistanceOfGunRack(id, src)
    local sourcePed = GetPlayerPed(src)
    local sourceCoords = GetEntityCoords(sourcePed)

    if #(sourceCoords - vec3(Racks[id].coords.x, Racks[id].coords.y, Racks[id].coords.z)) < 6 then
        return true
    end
    return false
end

RegisterServerEvent('js5m_gunrack:server:placeGunRack', function(coords, rot)
    local src = source
    local ped = GetPlayerPed(src)
    local sourceCoords = GetEntityCoords(ped)
    if #(sourceCoords - coords) > 5 then return end

    -- local Player = Ox.GetPlayer(src)
    if exports.ox_inventory:RemoveItem(src, 'gun_rack', 1) then
        local rackData = {
            coords = {x = coords.x, y = coords.y, z = coords.z, w = rot},
            rifles = {},
            taser = false,
        }
        local id = MySQL.Sync.insert('INSERT INTO gunracks (coords, rifles, taser) VALUES (@coords, @rifles, @taser)', {
            ['@coords'] = json.encode(rackData.coords),
            ['@rifles'] = json.encode(rackData.rifles),
            ['@taser'] = rackData.taser and 1 or 0
        })
        rackData.id = id
        Racks[id] = rackData
        TriggerClientEvent('js5m_gunrack:client:placeGunRack', -1, id, rackData)

        -- local insertedId = db.createGunRack(rackData)
        -- Racks[insertedId] = rackData
        -- TriggerClientEvent('js5m_gunrack:client:placeGunRack', -1, insertedId, rackData)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don\'t have a Gun Rack", "error")
    end
end)

RegisterServerEvent('js5m_gunrack:server:storeWeapon', function(rackIndex, weaponSlot, weaponName )
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    if not Config.rackableWeapons[weaponName] then return end
    local rackSlot = getRifleSlot(rackIndex)
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
            rackInfo.rifles[rackSlot] = data
            -- db.saveGunRack(rackIndex, rackInfo)
            MySQL.Async.execute('UPDATE gunracks SET rifles = @rifles WHERE id = @id', {
                ['@rifles'] = json.encode(rackInfo.rifles),
                ['@id'] = rackIndex
            })
            TriggerClientEvent('js5m_gunrack:client:storeWeapon', -1, rackIndex, rackSlot, data)
        else
            --something fukt
        end
    else
    end
end)

RegisterServerEvent('js5m_gunrack:server:takeWeapon', function(rackIndex, rackSlot, weaponName )
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    if ox_inventory:AddItem(src, weaponName, 1, Racks[rackIndex].rifles[rackSlot].metadata) then
        local rackInfo = Racks[rackIndex]
        rackInfo.rifles[rackSlot] = {name = nil, available = true}
        -- db.saveGunRack(rackIndex, rackInfo)
        MySQL.Async.execute('UPDATE gunracks SET rifles = @rifles WHERE id = @id', {
            ['@rifles'] = json.encode(rackInfo.rifles),
            ['@id'] = rackIndex
        })
        TriggerClientEvent('js5m_gunrack:client:takeWeapon', -1, rackIndex, rackSlot)
    else
    end
    
end)

RegisterServerEvent('js5m_gunrack:server:destroyGunRack', function(rackIndex)
    local src = source
    if not inDistanceOfGunRack(rackIndex, src) then return end
    if not Racks[rackIndex] then return end
    Racks[rackIndex] = nil
    -- db.deleteGunRack(rackIndex)
    MySQL.Async.execute('DELETE FROM gunracks WHERE id = @id', {
        ['@id'] = rackIndex
    })
    TriggerClientEvent('js5m_gunrack:client:destroyGunRack', -1, rackIndex)
end)

lib.callback.register('js5m_gunrack:server:getRacks', function(source)
    return Racks
end)
