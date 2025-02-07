local ludb = exports['0xludb-fivem']
local db = {}

local idTables = {
    'gunracks',
}

for i=1, #idTables do
    local result = ludb:retrieveGlobal("ids/"..idTables[i])
    if not result then
        ludb:saveGlobal("ids/"..idTables[i], 1)
    end
end

function db.getAllGunRacks()
    return ludb:retrieve("gunracks/*") or {}
end

function db.createGunRack(gunrackInfo)
    local id = ludb:retrieveGlobal("ids/gunracks")
    ludb:saveGlobal("ids/gunracks", id+1)
    ludb:save("gunracks/"..id, gunrackInfo)
    return id
end

function db.saveGunRack(id, gunrackInfo, weaponType)
    local result = ludb:retrieve("gunracks/"..id)
    result[weaponType] = gunrackInfo[weaponType]
    ludb:save("gunracks/"..id, result)
end

function db.deleteGunRack(id)
    ludb:delete("gunracks/"..id)
end

Racks = db.getAllGunRacks()

return db