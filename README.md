![image](https://github.com/JoeSzymkowiczFiveM/js5m_gunrack/assets/70592880/2bf98aaa-6a64-4bad-b905-38d7dad4d09f)
## Description
This is a script to place a gun rack in the world, and use it for storing weapons.

## Usage
Use the `gunrack` item in your inventory to start the placement process. Once you've placed the rack, you can then target the rack to store weapons in it, or take weapons from it.

## Items
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

## Make Your Own Tapes

See the config for information about the tape items.

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-target] - This was used because ox_target has backwards compatibility for qb-target, so it will work with that aswell.
- [ox_inventory](https://github.com/overextended/ox_inventory) - Using my own fork of HyperSound as the original has been archived. Huge credit to charleshacks for creating this. It's a far-superior version of 3d sound than my original attempt.

## Discord
[Joe Szymkowicz FiveM Development](https://discord.gg/5vPGxyCB4z)
