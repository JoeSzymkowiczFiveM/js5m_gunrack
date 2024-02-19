![image](https://github.com/JoeSzymkowiczFiveM/js5m_gunrack/assets/70592880/2bf98aaa-6a64-4bad-b905-38d7dad4d09f)
## ✨ Description
This is a script to place a gun rack in the world, and use it for storing weapons.

## 👀 Usage
Use the `gunrack` item in your inventory to start the placement process. Once you've placed the rack, you can then target the rack to store weapons in it, or take weapons from it.

## 📚 Items
You will need to add a `gunrack` item to your inventory items list.

```
['gunrack'] = {
  label = 'Gun Rack',
  weight = 10000,
  stack = false,
  consume = 0,
  client = {
      export = 'js5m_gunrack.placeGunRack',
  },
},
```

## 🔗 Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- qb-target - This was used because ox_target has backwards compatibility for qb-target, so it will work with that aswell.
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [oxmysql](https://github.com/overextended/oxmysql)

## 👐 Credit
A huge thank you to [FjamZoo](https://github.com/FjamZoo) for his research and work with weapons components and skins. Thanks to [Snipe](https://github.com/pushkart2) for writing the MySQL module code for this. Also, huge shoutout to the [Overextended](https://github.com/overextended) group for their continued work on the ox resources. A big thank you to the guy that was selling roughly this same thing for €120 on the Releases forum, for the motivation to work on this. Keep FiveM free!


## ✅ TODO
- Add taser/ammo/armor storage
- Optimize offsets and rotations
- Add `prop_cs_gunrack` functionality

## Discord
[Joe Szymkowicz FiveM Development](https://discord.gg/5vPGxyCB4z)
