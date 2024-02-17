Config = {}

Config.rackableWeapons = {
    ['WEAPON_PISTOL'] = {label = 'Pistol', model = 'w_pi_pistol', offset = {z = 0.1}},
    ['WEAPON_PISTOL_MK2'] = {label = 'Pistol Mk2', model = 'w_pi_pistolmk2', offset = {z = 0.1}},
    ['WEAPON_COMBATPISTOL'] = {label = 'Combat Pistol', model = 'w_pi_combatpistol', offset = {z = 0.1}},
    ['WEAPON_APPISTOL'] = {label = 'AP Pistol', model = 'w_pi_appistol', offset = {z = 0.1}},
    ['WEAPON_PISTOL50'] = {label = 'Pistol 50', model = 'w_pi_pistol50', offset = {z = 0.1}},
    ['WEAPON_SNSPISTOL'] = {label = 'SNS Pistol', model = 'w_pi_sns_pistol', offset = {z = 0.1}},
    ['WEAPON_SNSPISTOL_MK2'] = {label = 'SNS Pistol Mk2', model = 'w_pi_sns_pistolmk2', offset = {z = 0.1}},
    ['WEAPON_HEAVYPISTOL'] = {label = 'Heavy Pistol', model = 'w_pi_heavypistol', offset = {z = 0.1}},
    ['WEAPON_VINTAGEPISTOL'] = {label = 'Vintage Pistol', model = 'w_pi_vintage_pistol', offset = {z = 0.1}},
    ['WEAPON_MARKSMANPISTOL'] = {label = 'Marksman Pistol', model = 'w_pi_sns_pistol', offset = {z = 0.1}},
    ['WEAPON_REVOLVER'] = {label = 'Revolver', model = 'w_pi_revolver', offset = {z = 0.1}},
    ['WEAPON_REVOLVER_MK2'] = {label = 'Revolver Mk2', model = 'w_pi_revolvermk2', offset = {z = 0.1}},
    ['WEAPON_DOUBLEACTION'] = {label = 'Double Action Revolver', model = 'w_pi_doubleaction', offset = {z = 0.1}},
    ['WEAPON_MICROSMG'] = {label = 'Micro SMG', model = 'w_sb_microsmg', offset = {z = 0.1}},
    ['WEAPON_SMG'] = {label = 'SMG', model = 'w_sb_smg', offset = {z = 0.65}},
    ['WEAPON_SMG_MK2'] = {label = 'SMG Mk2', model = 'w_sb_smgmk2', offset = {z = 0.65}},
    ['WEAPON_ASSAULTSMG'] = {label = 'Assault SMG', model = 'w_sb_assaultsmg', offset = {y = 0.1, z = 0.75}},
    ['WEAPON_COMBATPDW'] = {label = 'Combat PDW', model = 'w_sb_pdw', offset = {z = 0.1}},
    ['WEAPON_MACHINEPISTOL'] = {label = 'Machine Pistol', model = 'w_sb_pdw', offset = {z = 0.1}},
    ['WEAPON_MINISMG'] = {label = 'Mini SMG', model = 'w_sb_minismg', offset = {z = 0.50}},
    ['WEAPON_ASSAULTRIFLE'] = {label = 'Assault Rifle', model = 'w_ar_assaultrifle', offset = {z = 0.65}},
    ['WEAPON_ASSAULTRIFLE_MK2'] = {label = 'Assault Rifle Mk2', model = 'w_ar_assaultriflemk2', offset = {z = 0.65}},
    ['WEAPON_CARBINERIFLE'] = {label = 'Carbine Rifle', model = 'w_ar_carbinerifle', offset = {z = 0.60}},
    ['WEAPON_CARBINERIFLE_MK2'] = {label = 'Carbine Rifle Mk2', model = 'w_ar_carbineriflemk2', offset = {z = 0.68}},
    ['WEAPON_ADVANCEDRIFLE'] = {label = 'Advanced Rifle', model = 'w_ar_advancedrifle', offset = {z = 0.77}},
    ['WEAPON_SPECIALCARBINE'] = {label = 'Special Carbine', model = 'w_ar_specialcarbine', offset = {z = 0.1}},
    ['WEAPON_BULLPUPRIFLE'] = {label = 'Bullpup Rifle', model = 'w_ar_bullpuprifle', offset = {z = 0.80}},
    ['WEAPON_BULLPUPRIFLE_MK2'] = {label = 'Bullpup Rifle Mk2', model = 'w_ar_bullpupriflemk2', offset = {z = 0.67}},
    ['WEAPON_COMPACTRIFLE'] = {label = 'Compact Rifle', model = 'w_ar_compactrifle', offset = {z = 0.1}},
    ['WEAPON_MG'] = {label = 'MG', model = 'w_mg_mg', offset = {z = 0.1}},
    ['WEAPON_COMBATMG'] = {label = 'Combat MG', model = 'w_mg_combatmg', offset = {z = 0.1}},
    ['WEAPON_COMBATMG_MK2'] = {label = 'Combat MG Mk2', model = 'w_mg_combatmgmk2', offset = {z = 0.1}},
    ['WEAPON_GUSENBERG'] = {label = 'Gusenberg', model = 'w_mg_gusenberg', offset = {z = 0.1}},
    ['WEAPON_SNIPERRIFLE'] = {label = 'Sniper Rifle', model = 'w_sr_sniperrifle', offset = {z = 0.72}},
    ['WEAPON_HEAVYSNIPER'] = {label = 'Heavy Sniper', model = 'w_sr_heavysniper', offset = {z = 0.72}},
    ['WEAPON_MARKSMANRIFLE'] = {label = 'Marksman Rifle', model = 'w_sr_marksmanrifle', offset = {z = 0.72}},
    ['WEAPON_MARKSMANRIFLE_MK2'] = {label = 'Marksman Rifle Mk2', model = 'w_sr_marksmanriflemk2', offset = {z = 0.72}},
    ['WEAPON_RPG'] = {label = 'RPG', model = 'w_lr_rpg', offset = {z = 0.1}},
    ['WEAPON_GRENADELAUNCHER'] = {label = 'Grenade Launcher', model = 'w_lr_grenadelauncher', offset = {z = 0.1}},
    ['WEAPON_GRENADELAUNCHER_SMOKE'] = {label = 'Smoke Grenade Launcher', model = 'w_lr_grenadelaunchersmoke', offset = {z = 0.1}},
    ['WEAPON_MINIGUN'] = {label = 'Minigun', model = 'w_mg_minigun', offset = {z = 0.1}},
    ['WEAPON_FIREWORK'] = {label = 'Firework Launcher', model = 'w_lr_firework', offset = {z = 0.1}},
    ['WEAPON_RAILGUN'] = {label = 'Railgun', model = 'w_ar_railgun', offset = {z = 0.1}},
    ['WEAPON_HOMINGLAUNCHER'] = {label = 'Homing Launcher', model = 'w_lr_homing', offset = {z = 0.1}}
}