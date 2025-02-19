local ChiliadDB = ChiliadDB
local db = {}

function db.getAllGunRacks()
    return ChiliadDB.find({ collection = 'gunracks'})
end

function db.createGunRack(gunrackInfo)
    return ChiliadDB.insert({ collection = 'gunracks', document = gunrackInfo})
end

function db.saveGunRack(id, gunrackInfo, weaponType)
    ChiliadDB.update({ collection = 'gunracks', query = { id = id}, update = {[weaponType] = gunrackInfo[weaponType]}})
end

function db.deleteGunRack(id)
    ChiliadDB.delete({ collection = 'gunracks', query = { id = id}})
end

ChiliadDB.ready(function()
    Racks = db.getAllGunRacks()
    RacksLoaded = true
end)

return db