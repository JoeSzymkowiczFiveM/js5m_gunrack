local db = {}
local MySQL = MySQL

function db.getAllGunRacks()
    local responseRacks = {}
    local result = MySQL.Sync.fetchAll("SELECT * FROM gunracks")
    for k, v in pairs(result) do        
        responseRacks[v.id] = {
            coords = json.decode(v.coords),
            rifles = json.decode(v.rifles),
            pistols = json.decode(v.pistols),
            taser = v.taser == 1 and true or false
        }
    end
    return responseRacks
end

function db.createGunRack(gunrackInfo)
    return MySQL.Sync.insert('INSERT INTO gunracks (coords, rifles, pistols, taser, job) VALUES (@coords, @rifles, @pistols, @taser, job)', {
        ['@coords'] = json.encode(gunrackInfo.coords),
        ['@rifles'] = json.encode(gunrackInfo.rifles),
        ['@pistols'] = json.encode(gunrackInfo.pistols),
        ['@taser'] = gunrackInfo.taser and '1' or '0',
        ['@job'] = json.encode(gunrackInfo.job),
    })
end

function db.saveGunRack(id, gunrackInfo, weaponType)
    if weaponType == 'pistols' then
        MySQL.Async.execute('UPDATE gunracks SET pistols = @pistols WHERE id = @id', {
            ['@pistols'] = json.encode(gunrackInfo.pistols),
            ['@id'] = id
        })
        return
    end
    
    MySQL.Async.execute('UPDATE gunracks SET rifles = @rifles WHERE id = @id', {
        ['@rifles'] = json.encode(gunrackInfo.rifles),
        ['@id'] = id
    })
end

function db.deleteGunRack(id)
    MySQL.Async.execute('DELETE FROM gunracks WHERE id = @id', {
        ['@id'] = id
    })
end

MySQL.ready(function()
    Racks = db.getAllGunRacks()
end)

return db