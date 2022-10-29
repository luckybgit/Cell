--[[
-- File: Layout_Defaults_Wrath.lua
-- Author: enderneko (enderneko-dev@outlook.com)
-- File Created: 2022/08/21 04:06:04 +0800
-- Last Modified: 2022/10/30 06:22:20 +0800
--]]

local addonName, Cell = ...

-- number of built-in indicators
Cell.defaults.builtIns = 24

Cell.defaults.indicatorIndices = {
    ["nameText"] = 1,
    ["statusText"] = 2,
    ["healthText"] = 3,
    ["healthThresholds"] = 4,
    ["statusIcon"] = 5,
    ["roleIcon"] = 6,
    ["leaderIcon"] = 7,
    ["readyCheckIcon"] = 8,
    ["playerRaidIcon"] = 9,
    ["targetRaidIcon"] = 10,
    ["aggroBlink"] = 11,
    ["aggroBar"] = 12,
    ["aggroBorder"] = 13,
    ["shieldBar"] = 14,
    ["aoeHealing"] = 15,
    ["externalCooldowns"] = 16,
    ["defensiveCooldowns"] = 17,
    ["allCooldowns"] = 18,
    ["dispels"] = 19,
    ["debuffs"] = 20,
    ["raidDebuffs"] = 21,
    ["targetedSpells"] = 22,
    ["targetCounter"] = 23,
    ["consumables"] = 24,
}

Cell.defaults.layout = {
    -- ["syncWith"] = "layoutName",
    ["size"] = {66, 46},
    ["position"] = {},
    ["powerSize"] = 2,
    ["spacing"] = 3,
    ["orientation"] = "vertical",
    ["barOrientation"] = {"horizontal", false},
    ["anchor"] = "TOPLEFT",
    ["columns"] = 8,
    ["rows"] = 8,
    ["groupSpacing"] = 0,
    ["groupFilter"] = {true, true, true, true, true, true, true, true},
    ["friendlyNPC"] = {true, false, {}},
    ["pet"] = {true, false, {}, false, {66, 46}}, -- partyPetsEnabled, raidPetsEnabled, raidPetsPosition, sizeEnabled, size
    ["spotlight"] = {false, {}, {}, false, {66, 46}}, -- enabled, units, position, sizeEnabled, size
    ["powerFilters"] = {
        ["DEATHKNIGHT"] = {["TANK"] = true, ["DAMAGER"] = true},
        ["DRUID"] = {["TANK"] = true, ["DAMAGER"] = true, ["HEALER"] = true},
        ["HUNTER"] = true,
        ["MAGE"] = true,
        ["PALADIN"] = {["TANK"] = true, ["DAMAGER"] = true, ["HEALER"] = true},
        ["PRIEST"] = {["DAMAGER"] = true, ["HEALER"] = true},
        ["ROGUE"] = true,
        ["SHAMAN"] = {["DAMAGER"] = true, ["HEALER"] = true},
        ["WARLOCK"] = true,
        ["WARRIOR"] = {["TANK"] = true, ["DAMAGER"] = true},
        ["PET"] = true,
        ["VEHICLE"] = true,
        ["NPC"] = true,
    },
    ["indicators"] = {
        {
            ["name"] = "Name Text",
            ["indicatorName"] = "nameText",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"CENTER", "CENTER", 0, 0},
            ["frameLevel"] = 1,
            ["font"] = {"Cell ".._G.DEFAULT, 13, "Shadow"},
            ["nameColor"] = {"custom", {1, 1, 1}},
            ["vehicleNamePosition"] = {"TOP", 0},
            ["textWidth"] = {"percentage", 0.75},
            ["showGroupNumber"] = false,
        }, -- 1
        {
            ["name"] = "Status Text",
            ["indicatorName"] = "statusText",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"BOTTOM", 0},
            ["frameLevel"] = 30,
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Shadow"},
            ["colors"] = {
                ["AFK"] = {1, 0.19, 0.19, 1},
                ["OFFLINE"] = {1, 0.19, 0.19, 1},
                ["DEAD"] = {1, 0.19, 0.19, 1},
                ["GHOST"] = {1, 0.19, 0.19, 1},
                ["FEIGN"] = {1, 1, 0.12, 1},
                ["DRINKING"] = {0.12, 0.75, 1, 1},
                ["PENDING"] = {1, 1, 0.12, 1},
                ["ACCEPTED"] = {0.12, 1, 0.12, 1},
                ["DECLINED"] = {1, 0.19, 0.19, 1},
            },
        }, -- 2
        {
            ["name"] = "Health Text",
            ["indicatorName"] = "healthText",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["position"] = {"TOP", "CENTER", 0, -5},
            ["frameLevel"] = 2,
            ["font"] = {"Cell ".._G.DEFAULT, 10, "Shadow"},
            ["color"] = {1, 1, 1},
            ["format"] = "percentage",
            ["hideFull"] = true,
        }, -- 3
        {
            ["name"] = "Health Thresholds",
            ["indicatorName"] = "healthThresholds",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["thickness"] = 1,
            ["thresholds"] = {
                {0.35, {1, 0, 0, 1}},
            },
        }, -- 4
        {
            ["name"] = "Status Icon",
            ["indicatorName"] = "statusIcon",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"TOP", "TOP", 0, -3},
            ["frameLevel"] = 10,
            ["size"] = {18, 18},
        }, -- 5
        {
            ["name"] = "Role Icon",
            ["indicatorName"] = "roleIcon",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["hideDamager"] = false,
            ["position"] = {"TOPLEFT", "TOPLEFT", 0, 0},
            ["size"] = {11, 11},
            ["roleTexture"] = {"default", "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Tank.tga", "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\Healer.tga", "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\DPS.tga"},
        }, -- 6
        {
            ["name"] = "Leader Icon",
            ["indicatorName"] = "leaderIcon",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"TOPLEFT", "TOPLEFT", 0, -11},
            ["size"] = {11, 11},
        }, -- 7
        {
            ["name"] = "Ready Check Icon",
            ["indicatorName"] = "readyCheckIcon",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["frameLevel"] = 100,
            ["size"] = {16, 16},
        }, -- 8
        {
            ["name"] = "Raid Icon (player)",
            ["indicatorName"] = "playerRaidIcon",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"TOP", "TOP", 0, 3},
            ["frameLevel"] = 2,
            ["size"] = {14, 14},
            ["alpha"] = 0.77,
        }, -- 9
        {
            ["name"] = "Raid Icon (target)",
            ["indicatorName"] = "targetRaidIcon",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["position"] = {"TOP", "TOP", -14, 3},
            ["frameLevel"] = 2,
            ["size"] = {14, 14},
            ["alpha"] = 0.77,
        }, -- 10
        {
            ["name"] = "Aggro (blink)",
            ["indicatorName"] = "aggroBlink",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"TOPLEFT", "TOPLEFT", 0, 0},
            ["frameLevel"] = 3,
            ["size"] = {10, 10},
        }, -- 11
        {
            ["name"] = "Aggro (bar)",
            ["indicatorName"] = "aggroBar",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"BOTTOMLEFT", "TOPLEFT", 1, 0},
            ["frameLevel"] = 1,
            ["size"] = {18, 2},
        }, -- 12
        {
            ["name"] = "Aggro (border)",
            ["indicatorName"] = "aggroBorder",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["frameLevel"] = 3,
            ["thickness"] = 3,
        }, -- 13
        {
            ["name"] = "Shield Bar",
            ["indicatorName"] = "shieldBar",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["position"] = {"BOTTOMLEFT", "BOTTOMLEFT", 0, 0},
            ["frameLevel"] = 2,
            ["height"] = 4,
            ["color"] = {1, 1, 0, 1},
        }, -- 14
        {
            ["name"] = "AoE Healing",
            ["indicatorName"] = "aoeHealing",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["height"] = 15,
            ["color"] = {1, 1, 0},
        }, -- 15
        {
            ["name"] = "External Cooldowns",
            ["indicatorName"] = "externalCooldowns",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"RIGHT", "RIGHT", 2, 5},
            ["frameLevel"] = 10,
            ["size"] = {12, 20},
            ["showDuration"] = false,
            ["num"] = 2,
            ["orientation"] = "right-to-left",
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
        }, -- 16
        {
            ["name"] = "Defensive Cooldowns",
            ["indicatorName"] = "defensiveCooldowns",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"LEFT", "LEFT", -2, 5},
            ["frameLevel"] = 10,
            ["size"] = {12, 20},
            ["showDuration"] = false,
            ["num"] = 2,
            ["orientation"] = "left-to-right",
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
        }, -- 17
        {
            ["name"] = "Externals + Defensives",
            ["indicatorName"] = "allCooldowns",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["position"] = {"LEFT", "LEFT", -2, 5},
            ["frameLevel"] = 10,
            ["size"] = {12, 20},
            ["showDuration"] = false,
            ["num"] = 2,
            ["orientation"] = "left-to-right",
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
        }, -- 18
        {
            ["name"] = "Dispels",
            ["indicatorName"] = "dispels",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"BOTTOMRIGHT", "BOTTOMRIGHT", 0, 4},
            ["frameLevel"] = 15,
            ["size"] = {12, 12},
            ["dispellableByMe"] = true,
            ["highlightType"] = "gradient",
            ["showDispelTypeIcons"] = true,
        }, -- 19
        {
            ["name"] = "Debuffs",
            ["indicatorName"] = "debuffs",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"BOTTOMLEFT", "BOTTOMLEFT", 1, 4},
            ["frameLevel"] = 2,
            ["size"] = {{13, 13}, {17, 17}},
            ["showDuration"] = false,
            ["showTooltip"] = false,
            ["num"] = 3,
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
            ["dispellableByMe"] = false,
            ["orientation"] = "left-to-right",
        }, -- 20
        {
            ["name"] = "Raid Debuffs",
            ["indicatorName"] = "raidDebuffs",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"CENTER", "CENTER", 0, 3},
            ["frameLevel"] = 20,
            ["size"] = {22, 22},
            ["border"] = 2,
            ["num"] = 1,
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
            -- ["durationFont"] = {true, "Cell ".._G.DEFAULT, 11, "Outline", "RIGHT", 2, 0},
            -- ["stackFont"] = {"Cell ".._G.DEFAULT, 11, "Outline", "RIGHT", 2, 0},
            ["onlyShowTopGlow"] = true,
            ["orientation"] = "left-to-right",
            ["showTooltip"] = false,
        }, -- 21
        {
            ["name"] = "Targeted Spells",
            ["indicatorName"] = "targetedSpells",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["position"] = {"CENTER", "TOPLEFT", 7, -7},
            ["frameLevel"] = 50,
            ["size"] = {20, 20},
            ["border"] = 2,
            -- ["glow"] = {"Pixel", {0.95,0.95,0.32,1}, 9, 0.25, 8, 2},
            ["font"] = {"Cell ".._G.DEFAULT, 12, "Outline", 2, 1},
        }, -- 22
        {
            ["name"] = "Target Counter",
            ["indicatorName"] = "targetCounter",
            ["type"] = "built-in",
            ["enabled"] = false,
            ["position"] = {"TOP", "TOP", 0, 5},
            ["frameLevel"] = 15,
            ["font"] = {"Cell ".._G.DEFAULT, 15, "Outline"},
            ["color"] = {1, 0.1, 0.1},
        }, -- 23
        {
            ["name"] = "Consumables",
            ["indicatorName"] = "consumables",
            ["type"] = "built-in",
            ["enabled"] = true,
            ["speed"] = 1,
        }, -- 24
    },
}