local ox_inventory = exports.ox_inventory
local Racks = {}
local RenderDistance = 150
--prop_cs_gunrack
local rackModel = `xm_prop_xm_gunlocker_01a`
local tempRackObj = nil

local Keys = {
	["Q"] = 44, ["E"] = 38, ["ENTER"] = 18, ["X"] = 73
}

local function storeWeapon(rack, slot, name)
    TriggerServerEvent('js5m_gunrack:server:storeWeapon', rack, slot, name)
end

local function takeWeapon(rack, rackSlot, name)
    TriggerServerEvent('js5m_gunrack:server:takeWeapon', rack, rackSlot, name)
end

local function GetRackPositionOffset(rackIndex, slot, weapon)
    local rack = Racks[rackIndex].object
    local xOffset = -0.39
    if slot == 2 then
        xOffset = -0.28
    elseif slot == 3 then
        xOffset = -0.17
    elseif slot == 4 then
        xOffset = -0.06
    elseif slot == 5 then
        xOffset = 0.06
    end

    local zOffset = Config.rackableWeapons[weapon].offset.z or 0.0
    local yOffset = Config.rackableWeapons[weapon].offset.y or 0.0
    return GetOffsetFromEntityInWorldCoords(rack, xOffset, yOffset, zOffset)
end

local function spawnGun(rackId, slot)
    local rack = Racks[rackId]
    if not rack then return end
    local modelCoords = GetRackPositionOffset(rackId, slot, rack.rifles[slot].name)
    -- rack.rifles[slot].object = CreateObject(WeaponsModels[rack.rifles[slot].name].model, modelCoords.x, modelCoords.y, modelCoords.z, false, false, false)
    local hash = GetHashKey(rack.rifles[slot].name)
    lib.requestWeaponAsset(hash, 5000, 31, 0)
    rack.rifles[slot].object = CreateWeaponObject(hash, 50, modelCoords.x, modelCoords.y, modelCoords.z, true, 1.0, 0)
    FreezeEntityPosition(rack.rifles[slot].object, true)
    -- while not rack.rifles[slot].object do Wait(1) end
    SetEntityRotation(rack.rifles[slot].object, 1, 260, rack.coords.w - 90)
end

local function fadeGun(rackId, slot)
    local rack = Racks[rackId]
    if not rack then return end
    if rack.rifles[slot].object then
        DeleteEntity(rack.rifles[slot].object)
    end
end

local function fadeGunRack(id)
    local rack = Racks[id]
    if DoesEntityExist(rack.object) then
        for i=1, #rack.rifles do
            if rack.rifles[i].object then
                DeleteEntity(rack.rifles[i].object)
            end
        end
        exports.ox_target:removeLocalEntity(rack.object, {'gunrack:storeWeapon', 'gunrack:takeWeapon', 'gunrack:destroyGunRack'})
        DeleteEntity(rack.object)
        rack.object = nil
        rack.isRendered = false
    end
end

local function displayPlayerWeapons(data)
    local registeredMenu = {
        id = 'js5m_gunrack_storeWeaponsMenu',
        title = 'Store Weapons',
        options = {}
    }
    local options = {}

    local items = ox_inventory:GetPlayerItems()
    for k, v in pairs(items) do
        if Config.rackableWeapons[v.name] then
            options[#options+1] = {
                title = 'Store ' .. v.label,
                onSelect = function()
                    storeWeapon(data.args.rack, v.slot, v.name)
                end
            }
        end
    end

    if #options == 0 then
        options[#options+1] = {
            title = 'No weapons to store',
            disabled = true
        }
    end

    registeredMenu["options"] = options
    
    lib.registerContext(registeredMenu)
    lib.showContext('js5m_gunrack_storeWeaponsMenu')
end

local function takeRackWeapons(data)
    local rack = Racks[data.args.rack]
    local registeredMenu = {
        id = 'js5m_gunrack_takeWeaponsMenu',
        title = 'Take Weapons',
        options = {}
    }
    local options = {}

    for i=1, #rack.rifles do
        local item = rack.rifles[i]
        if item.name then
            options[#options+1] = {
                title = 'Take ' .. item.name,
                onSelect = function()
                    takeWeapon(data.args.rack, i, item.name)
                end
            }
        end
    end

    if #options == 0 then
        options[#options+1] = {
            title = 'No weapons to take',
            disabled = true
        }
    end

    registeredMenu["options"] = options
    
    lib.registerContext(registeredMenu)
    lib.showContext('js5m_gunrack_takeWeaponsMenu')
end

local function destroyGunRack(data)
    local rack = data.args.rack
    lib.alertDialog({
        header = 'Destroy the gun rack?',
        content = 'Are you sure that you want to destroy this build? You will lose all the contents.',
        centered = true,
        cancel = true
    })

    TriggerServerEvent('js5m_gunrack:server:destroyGunRack', rack)
end

local function spawnGunRack(id)
    local rack = Racks[id]
    lib.requestModel(rackModel)
    rack.object = CreateObject(rackModel, rack.coords.x, rack.coords.y, rack.coords.z, false, false, false)
    SetEntityHeading(rack.object, rack.coords.w)
    SetEntityAlpha(rack.object, 0)
    PlaceObjectOnGroundProperly(rack.object)
    FreezeEntityPosition(rack.object, true)
    
    exports.ox_target:addLocalEntity(rack.object, {
        {
            label = 'Store Weapon',
            name = 'gunrack:storeWeapon',
            icon = 'fas fa-box',
            distance = 1.5,
            onSelect = displayPlayerWeapons,
            args = {rack = id}
        },
        {
            label = 'Take Weapon',
            name = 'gunrack:takeWeapon',
            icon = 'fas fa-box',
            distance = 1.5,
            onSelect = takeRackWeapons,
            args = {rack = id}
        },
        {
            label = 'Destroy Gun Rack',
            name = 'gunrack:destroyGunRack',
            icon = 'fas fa-box',
            distance = 1.5,
            onSelect = destroyGunRack,
            args = {rack = id}
        }
    })

    for i = 0, 255, 51 do
        Wait(50)
        SetEntityAlpha(rack.object, i, false)
    end
    rack.isRendered = true
    for i=1, #rack.rifles do
        if not rack.rifles[i].available then
            spawnGun(id, i)
        end
    end
end

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestSweptSphere(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, 0.2, 339, PlayerPedId(), 4))
	return b, c, e
end

local PlacingObject = false
exports('placeGunRack', function()
    if PlacingObject then return end
    local playerCoords = GetEntityCoords(cache.ped)
    lib.requestModel(rackModel)
    tempRackObj = CreateObject(rackModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, false)
    local heading = 0.0
    SetEntityHeading(tempRackObj, 0)
    
    SetEntityAlpha(tempRackObj, 225)
    SetEntityCollision(tempRackObj, false, false)
    -- SetEntityInvincible(tempRackObj, true)
    FreezeEntityPosition(tempRackObj, true)

    PlacingObject = true
    local plantCoords = nil
    local plantHeading = nil
    local inRange = false

    local function deletePlant()
        PlacingObject = false
        SetEntityDrawOutline(tempRackObj, false)
        DeleteEntity(tempRackObj)
        tempRackObj = nil
        lib.hideTextUI()
    end

    lib.showTextUI(
        '**[Q/E]**   -   Rotate  \n' ..
        '**[ENTER]**   -   Place gun rack  \n' ..
        '**[X]**   -   Abandon  \n'
    )

    CreateThread(function()
        while PlacingObject do
            local hit, coords, entity = RayCastGamePlayCamera(20.0)
            plantCoords = coords
            DisableControlAction( 0, Keys["Q"], true ) -- cover
            DisableControlAction( 0, Keys["E"], true ) -- cover

            if hit then
                SetEntityCoords(tempRackObj, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(tempRackObj)
                SetEntityDrawOutline(tempRackObj, true)
            end

            if #(plantCoords - GetEntityCoords(cache.ped)) < 2.0 then
                SetEntityDrawOutlineColor(2, 241, 181, 255)
                inRange = true
            else --not in range
                inRange = false
                SetEntityDrawOutlineColor(244, 68, 46, 255)
            end

            if IsControlPressed(0, Keys["X"]) then
                deletePlant()
                PlacingObject = false
            end
            
            if IsDisabledControlPressed(0, Keys["Q"]) then
                heading = heading + 2
                if heading > 360 then heading = 0.0 end
            end
    
            if IsDisabledControlPressed(0, Keys["E"]) then
                heading = heading - 2
                if heading < 0 then heading = 360.0 end
            end

            SetEntityHeading(tempRackObj, heading)
            if IsControlJustPressed(0, Keys["ENTER"]) then
                if not IsPedOnFoot(cache.ped) then
                    deletePlant()
                    return
                end
                if not inRange then 
                    -- QBCore.Functions.Notify('You are not close enough to plant', 'error', 3500)
                    deletePlant()
                    return
                end
                local rackRot = GetEntityHeading(tempRackObj)
                local rackCoords = GetEntityCoords(tempRackObj)
                deletePlant()

                TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_HAMMERING", 0, true)
                if lib.progressBar({
                    duration = 10000,
                    label = 'Building Gun Rack',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                }) then
                    ClearPedTasks(cache.ped)
                    TriggerServerEvent('js5m_gunrack:server:placeGunRack', rackCoords, rackRot)
                else
                    ClearPedTasks(cache.ped)
                end
            end
        Wait(0)
        end
    end)
end)

RegisterNetEvent('js5m_gunrack:client:placeGunRack', function(id, data)
    if source == '' then return end
    Racks[id] = data
end)

RegisterNetEvent('js5m_gunrack:client:storeWeapon', function(rackIndex, rackSlot, weaponName)
    if source == '' then return end
    Racks[rackIndex].rifles[rackSlot] = {name = weaponName, available = false}
    spawnGun(rackIndex, rackSlot)
end)

RegisterNetEvent('js5m_gunrack:client:takeWeapon', function(rackIndex, rackSlot)
    if source == '' then return end
    fadeGun(rackIndex, rackSlot)
    Racks[rackIndex].rifles[rackSlot] = {name = nil, available = true}
end)

RegisterNetEvent('js5m_gunrack:client:destroyGunRack', function(id)
    if source == '' then return end
    local rack = Racks[id]
    if rack.isRendered then
        fadeGunRack(id)
    end
    Racks[id] = nil
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for k, v in pairs(Racks) do
        for k, v in pairs(v.rifles) do
            if v.object then
                DeleteEntity(v.object)
            end
        end
        exports.ox_target:removeLocalEntity(v.object, {'gunrack:storeWeapon', 'gunrack:takeWeapon', 'gunrack:destroyGunRack'})
        DeleteEntity(v.object)
    end
    if tempRackObj then
        DeleteEntity(tempRackObj)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Racks = lib.callback.await('js5m_gunrack:server:getRacks', false)
end)

-- print(json.encode(result, {indent=true}))

CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(cache.ped)
        for k, rack in pairs(Racks) do
            local dist = #(playerCoords - vec3(rack.coords.x, rack.coords.y, rack.coords.z))
            if dist < RenderDistance and not rack.isRendered then
                spawnGunRack(k)
            elseif dist >= RenderDistance and rack.isRendered then
                fadeGunRack(k)
            end
        end
        Wait(2500)
    end
end)