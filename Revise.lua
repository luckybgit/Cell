local addonName, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs

function F:Revise()
    local dbRevision = CellDB["revise"] and tonumber(string.match(CellDB["revise"], "%d+")) or 0
    F:Debug("DBRevision:", dbRevision)

    if CellDB["revise"] and dbRevision < 54 then -- update from an extremely version
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function()
            f:UnregisterAllEvents()
            local popup = Cell:CreateConfirmPopup(CellMainFrame, 260, L["RESET"], function()
                CellDB = nil
                ReloadUI()
            end)
            popup:SetPoint("TOPLEFT")
        end)
        return
    end

    --[[
    -- r4-alpha add "castByMe"
    if not(CellDB["revise"]) or CellDB["revise"] < "r4-alpha" then
        for _, layout in pairs(CellDB["layouts"]) do
            for _, indicator in pairs(layout["indicators"]) do
                if indicator["auraType"] == "buff" then
                    if indicator["castByMe"] == nil then
                        indicator["castByMe"] = true
                    end
                elseif indicator["indicatorName"] == "dispels" then
                    if indicator["checkbutton"] then
                        indicator["dispellableByMe"] = indicator["checkbutton"][2]
                        indicator["checkbutton"] = nil
                    end
                end
            end
        end
    end

    -- r6-alpha
    if not(CellDB["revise"]) or CellDB["revise"] < "r6-alpha" then
        -- add "textWidth"
        for _, layout in pairs(CellDB["layouts"]) do
            if not layout["textWidth"] then
                layout["textWidth"] = .75
            end
        end
        -- remove old raid tools related
        if CellDB["showRaidSetup"] then CellDB["showRaidSetup"] = nil end
        if CellDB["pullTimer"] then CellDB["pullTimer"] = nil end
    end

    -- r13-release: fix all
    if not(CellDB["revise"]) or dbRevision < 13 then
        -- r8-beta: add "centralDebuff"
        for _, layout in pairs(CellDB["layouts"]) do
            if not layout["indicators"][8] or layout["indicators"][8]["indicatorName"] ~= "centralDebuff" then
                tinsert(layout["indicators"], 8, {
                    ["name"] = "Central Debuff",
                    ["indicatorName"] = "centralDebuff",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"CENTER", "CENTER", 0, 3},
                    ["size"] = {20, 20},
                    ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2},
                })
            end
        end

        -- r9-beta: fix raidtool db
        if type(CellDB["raidTools"]["showBattleRes"]) ~= "boolean" then CellDB["raidTools"]["showBattleRes"] = true end
        if not CellDB["raidTools"]["buttonsPosition"] then CellDB["raidTools"]["buttonsPosition"] = {"TOPRIGHT", "CENTER", 0, 0} end
        if not CellDB["raidTools"]["marksPosition"] then CellDB["raidTools"]["marksPosition"] = {"BOTTOMRIGHT", "CENTER", 0, 0} end

        -- r11-release: add horizontal layout
        for _, layout in pairs(CellDB["layouts"]) do
            if type(layout["orientation"]) ~= "string" then
                layout["orientation"] = "vertical"
            end
        end

        -- r13 release: CellDB["appearance"]
        if CellDB["texture"] then CellDB["appearance"]["texture"] = CellDB["texture"] end
        if CellDB["scale"] then CellDB["appearance"]["scale"] = CellDB["scale"] end
        if CellDB["font"] then CellDB["appearance"]["font"] = CellDB["font"] end
        if CellDB["outline"] then CellDB["appearance"]["outline"] = CellDB["outline"] end
        CellDB["texture"] = nil
        CellDB["scale"] = nil
        CellDB["font"] = nil
        CellDB["outline"] = nil
    end

    -- r14-release: CellDB["general"]
    if not(CellDB["revise"]) or dbRevision < 14 then
        if CellDB["hideBlizzard"] then CellDB["general"]["hideBlizzard"] = CellDB["hideBlizzard"] end
        if CellDB["disableTooltips"] then CellDB["general"]["disableTooltips"] = CellDB["disableTooltips"] end
        if CellDB["showSolo"] then CellDB["general"]["showSolo"] = CellDB["showSolo"] end
        CellDB["hideBlizzard"] = nil
        CellDB["disableTooltips"] = nil
        CellDB["showSolo"] = nil
    end
    
    -- r15-release
    if not(CellDB["revise"]) or dbRevision < 15 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- add powerHeight
            if type(layout["powerHeight"]) ~= "number" then
                layout["powerHeight"] = 2
            end
            -- add dispel highlight
            if layout["indicators"][6] and layout["indicators"][6]["indicatorName"] == "dispels" then
                if type(layout["indicators"][6]["enableHighlight"]) ~= "boolean" then
                    layout["indicators"][6]["enableHighlight"] = true
                end
            end
        end
        -- change showPets to showPartyPets
        if type(CellDB["general"]["showPartyPets"]) ~= "boolean" then
            CellDB["general"]["showPartyPets"] = CellDB["general"]["showPets"]
            CellDB["general"]["showPets"] = nil
        end
    end

    -- r22-release
    if not(CellDB["revise"]) or dbRevision < 22 then
        -- highlight color
        if not CellDB["appearance"]["targetColor"] then CellDB["appearance"]["targetColor"] = {1, .19, .19, .5} end
        if not CellDB["appearance"]["mouseoverColor"] then CellDB["appearance"]["mouseoverColor"] = {1, 1, 1, .5} end
        for _, layout in pairs(CellDB["layouts"]) do
            -- columns/rows
            if type(layout["columns"]) ~= "number" then layout["columns"] = 8 end
            if type(layout["rows"]) ~= "number" then layout["rows"] = 8 end
            if type(layout["groupSpacing"]) ~= "number" then layout["groupSpacing"] = 0 end
            -- targetMarker
            -- if layout["indicators"][1] and layout["indicators"][1]["indicatorName"] ~= "targetMarker" then
            -- 	tinsert(layout["indicators"], 1, {
            -- 		["name"] = "Target Marker",
            -- 		["indicatorName"] = "targetMarker",
            -- 		["type"] = "built-in",
            -- 		["enabled"] = true,
            -- 		["position"] = {"TOP", "TOP", 0, 3},
            -- 		["size"] = {14, 14},
            -- 		["alpha"] = .77,
            -- 	})
            -- end
        end
    end

    -- r23-release
    if not(CellDB["revise"]) or dbRevision < 23 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- rename targetMarker to playerRaidIcon
            if layout["indicators"][1] then
                if layout["indicators"][1]["indicatorName"] == "targetMarker" then -- r22
                    layout["indicators"][1]["name"] = "Raid Icon (player)"
                    layout["indicators"][1]["indicatorName"] = "playerRaidIcon"
                elseif layout["indicators"][1]["indicatorName"] == "aggroBar" then
                    tinsert(layout["indicators"], 1, {
                        ["name"] = "Raid Icon (player)",
                        ["indicatorName"] = "playerRaidIcon",
                        ["type"] = "built-in",
                        ["enabled"] = true,
                        ["position"] = {"TOP", "TOP", 0, 3},
                        ["size"] = {14, 14},
                        ["alpha"] = .77,
                    })
                end
            end
            if layout["indicators"][2] and layout["indicators"][2]["indicatorName"] ~= "targetRaidIcon" then
                tinsert(layout["indicators"], 2, {
                    ["name"] = "Raid Icon (target)",
                    ["indicatorName"] = "targetRaidIcon",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["position"] = {"TOP", "TOP", -14, 3},
                    ["size"] = {14, 14},
                    ["alpha"] = .77,
                })
            end
        end
    end

    -- r25-release
    if not(CellDB["revise"]) or dbRevision < 25 then
        -- position for raidTools
        if #CellDB["raidTools"]["marksPosition"] == 4 then CellDB["raidTools"]["marksPosition"] = {} end
        if #CellDB["raidTools"]["buttonsPosition"] == 4 then CellDB["raidTools"]["buttonsPosition"] = {} end
        -- position & anchor for layouts
        for _, layout in pairs(CellDB["layouts"]) do
            if type(layout["position"]) ~= "table" then
                layout["position"] = {}
            end
            if type(layout["anchor"]) ~= "string" then
                layout["anchor"] = "TOPLEFT"
            end
        end
        -- reset CellDB["debuffBlacklist"]
        CellDB["debuffBlacklist"] = I:GetDefaultDebuffBlacklist()
        -- update click-castings
        -- self:SetBindingClick(true, "MOUSEWHEELUP", self, "Button6")
        -- self:SetBindingClick(true, "SHIFT-MOUSEWHEELUP", self, "Button7")
        -- self:SetBindingClick(true, "CTRL-MOUSEWHEELUP", self, "Button8")
        -- self:SetBindingClick(true, "ALT-MOUSEWHEELUP", self, "Button9")
        -- self:SetBindingClick(true, "CTRL-SHIFT-MOUSEWHEELUP", self, "Button10")
        -- self:SetBindingClick(true, "ALT-SHIFT-MOUSEWHEELUP", self, "Button11")
        -- self:SetBindingClick(true, "ALT-CTRL-MOUSEWHEELUP", self, "Button12")
        -- self:SetBindingClick(true, "ALT-CTRL-SHIFT-MOUSEWHEELUP", self, "Button13")

        -- self:SetBindingClick(true, "MOUSEWHEELDOWN", self, "Button14")
        -- self:SetBindingClick(true, "SHIFT-MOUSEWHEELDOWN", self, "Button15")
        -- self:SetBindingClick(true, "CTRL-MOUSEWHEELDOWN", self, "Button16")
        -- self:SetBindingClick(true, "ALT-MOUSEWHEELDOWN", self, "Button17")
        -- self:SetBindingClick(true, "CTRL-SHIFT-MOUSEWHEELDOWN", self, "Button18")
        -- self:SetBindingClick(true, "ALT-SHIFT-MOUSEWHEELDOWN", self, "Button19")
        -- self:SetBindingClick(true, "ALT-CTRL-MOUSEWHEELDOWN", self, "Button20")
        -- self:SetBindingClick(true, "ALT-CTRL-SHIFT-MOUSEWHEELDOWN", self, "Button21")
        local replacements = {
            [6] = "type-SCROLLUP",
            [7] = "shift-type-SCROLLUP",
            [8] = "ctrl-type-SCROLLUP",
            [9] = "alt-type-SCROLLUP",
            [10] = "ctrl-shift-type-SCROLLUP",
            [11] = "alt-shift-type-SCROLLUP",
            [12] = "alt-ctrl-type-SCROLLUP",
            [13] = "alt-ctrl-shift-type-SCROLLUP",

            [14] = "type-SCROLLDOWN",
            [15] = "shift-type-SCROLLDOWN",
            [16] = "ctrl-type-SCROLLDOWN",
            [17] = "alt-type-SCROLLDOWN",
            [18] = "ctrl-shift-type-SCROLLDOWN",
            [19] = "alt-shift-type-SCROLLDOWN",
            [20] = "alt-ctrl-type-SCROLLDOWN",
            [21] = "alt-ctrl-shift-type-SCROLLDOWN",
        }
        for class, classTable in pairs(CellDB["clickCastings"]) do
            for spec, specTable in pairs(classTable) do
                if type(specTable) == "table" then -- not "useCommon"
                    for _, clickCastingTable in pairs(specTable) do
                        local keyID = tonumber(strmatch(clickCastingTable[1], "%d+"))
                        if keyID and keyID > 5 then
                            clickCastingTable[1] = replacements[keyID]
                        end
                    end
                end
            end
        end
    end

    -- r29-release
    if not(CellDB["revise"]) or dbRevision < 29 then
        for _, layout in pairs(CellDB["layouts"]) do
            for _, indicator in pairs(layout["indicators"]) do
                if indicator["type"] == "built-in" then
                    if indicator["indicatorName"] == "playerRaidIcon" then
                        indicator["frameLevel"] = 1
                    elseif indicator["indicatorName"] == "targetRaidIcon" then
                        indicator["frameLevel"] = 1
                    elseif indicator["indicatorName"] == "aggroBar" then
                        indicator["frameLevel"] = 1
                    elseif indicator["indicatorName"] == "externalCooldowns" then
                        indicator["frameLevel"] = 10
                    elseif indicator["indicatorName"] == "defensiveCooldowns" then
                        indicator["frameLevel"] = 10
                    elseif indicator["indicatorName"] == "tankActiveMitigation" then
                        indicator["frameLevel"] = 1
                    elseif indicator["indicatorName"] == "dispels" then
                        indicator["frameLevel"] = 15
                    elseif indicator["indicatorName"] == "debuffs" then
                        indicator["frameLevel"] = 1
                    elseif indicator["indicatorName"] == "centralDebuff" then
                        indicator["frameLevel"] = 20
                    end
                else
                    indicator["frameLevel"] = 5
                end
            end
        end
    end

    -- r33-release
    if CellDB["revise"] and dbRevision < 33 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- move health text
            local healthTextIndicator
            if layout["indicators"][11] and layout["indicators"][11]["indicatorName"] == "healthText" then
                healthTextIndicator = F:Copy(layout["indicators"][11])
                layout["indicators"][11] = nil
            else
                healthTextIndicator = {
                    ["name"] = "Health Text",
                    ["indicatorName"] = "healthText",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["position"] = {"TOP", "CENTER", 0, -5},
                    ["frameLevel"] = 1,
                    ["font"] = {"Cell ".._G.DEFAULT, 10, "Shadow", 0},
                    ["color"] = {1, 1, 1},
                    ["format"] = "percentage",
                    ["hideFull"] = true,
                }
            end

            -- add new
            if layout["indicators"][1]["indicatorName"] ~= "healthText" then
                tinsert(layout["indicators"], 1, healthTextIndicator)
                tinsert(layout["indicators"], 2, {
                    ["name"] = "Role Icon",
                    ["indicatorName"] = "roleIcon",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"TOPLEFT", "TOPLEFT", 0, 0},
                    ["size"] = {11, 11},
                })
                tinsert(layout["indicators"], 3, {
                    ["name"] = "Leader Icon",
                    ["indicatorName"] = "leaderIcon",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"TOPLEFT", "TOPLEFT", 0, -11},
                    ["size"] = {11, 11},
                })
                tinsert(layout["indicators"], 4, {
                    ["name"] = "Ready Check Icon",
                    ["indicatorName"] = "readyCheckIcon",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["frameLevel"] = 100,
                    ["size"] = {16, 16},
                })
                tinsert(layout["indicators"], 7, {
                    ["name"] = "Aggro Indicator",
                    ["indicatorName"] = "aggroIndicator",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"TOPLEFT", "TOPLEFT", 0, 0},
                    ["frameLevel"] = 2,
                    ["size"] = {10, 10},
                })
            end

            -- update centralDebuff border
            if layout["indicators"][15] and layout["indicators"][15]["indicatorName"] == "centralDebuff" then
                if not layout["indicators"][15]["border"] then
                    layout["indicators"][15]["border"] = 2
                    if layout["indicators"][15]["size"][1] == 20 then
                        layout["indicators"][15]["size"] = {22, 22}
                    end
                end
                if type(layout["indicators"][15]["onlyShowTopGlow"]) ~= "boolean" then
                    layout["indicators"][15]["onlyShowTopGlow"] = true
                end
            end
        end

        if not F:TContains(CellDB["debuffBlacklist"], 160029) then
            tinsert(CellDB["debuffBlacklist"], 2, 160029)
        end

        -- glow options for raidDebuffs
        for instance, iTable in pairs(CellDB["raidDebuffs"]) do
            for boss, bTable in pairs(iTable) do
                for spell, sTable in pairs(bTable) do
                    if type(sTable[2]) ~= "boolean" then
                        tinsert(sTable, 2, false)
                    end
                    if sTable[3] and sTable[4] and type(sTable[4][1]) == "number" then
                        local color = {sTable[4][1], sTable[4][2], sTable[4][3], 1}
                        if sTable[3] == "None" or sTable[3] == "Normal" then
                            sTable[4] = {color}
                        elseif sTable[3] == "Pixel" then
                            sTable[4] = {color, 9, .25, 8, 2}
                        elseif sTable[3] == "Shine" then
                            sTable[4] = {color, 9, 0.5, 1}
                        end
                    end
                end
            end
        end

        -- options ui font size
        if not CellDB["appearance"]["optionsFontSizeOffset"] then
            CellDB["appearance"]["optionsFontSizeOffset"] = 0
        end

        -- tooltips
        if type(CellDB["general"]["disableTooltips"]) == "boolean" then
            CellDB["general"]["enableTooltips"] = not CellDB["general"]["disableTooltips"]
            CellDB["general"]["disableTooltips"] = nil
        end
    end

    -- r36-release
    if CellDB["revise"] and dbRevision < 36 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- rename Central Debuff
            if layout["indicators"][15] and layout["indicators"][15]["indicatorName"] == "centralDebuff" then
                layout["indicators"][15]["indicatorName"] = "raidDebuffs"
                layout["indicators"][15]["name"] = "Raid Debuffs"
            end

            -- add Name Text
            if layout["indicators"][1]["indicatorName"] ~= "nameText" then
                tinsert(layout["indicators"], 1, {
                    ["name"] = "Name Text",
                    ["indicatorName"] = "nameText",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"CENTER", "CENTER", 0, 0},
                    ["font"] = {"Cell ".._G.DEFAULT, 13, "Shadow"},
                    ["nameColor"] = {"Custom Color", {1, 1, 1}},
                    ["vehicleNamePosition"] = {"TOP", 0},
                    ["textWidth"] = .75,
                })
            end

            -- add Status Text
            if layout["indicators"][2]["indicatorName"] ~= "statusText" then
                tinsert(layout["indicators"], 2, {
                    ["name"] = "Status Text",
                    ["indicatorName"] = "statusText",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"BOTTOM", 0},
                    ["frameLevel"] = 30,
                    ["font"] = {"Cell ".._G.DEFAULT, 11, "Shadow"},
                })
            end

            -- add Shiled Bar
            if layout["indicators"][11]["indicatorName"] ~= "shieldBar" then
                tinsert(layout["indicators"], 11, {
                    ["name"] = "Shield Bar",
                    ["indicatorName"] = "shieldBar",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["position"] = {"BOTTOMLEFT", "BOTTOMLEFT", 0, 0},
                    ["frameLevel"] = 1,
                    ["height"] = 4,
                    ["color"] = {1, 1, 0, 1},
                })
            end
        end
    end

    -- r37-release
    if CellDB["revise"] and dbRevision < 37 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- useCustomTexture
            if layout["indicators"][4] and layout["indicators"][4]["indicatorName"] == "roleIcon" then
                if type(layout["indicators"][4]["customTextures"]) ~= "table" then
                    layout["indicators"][4]["customTextures"] = {false, "Interface\\AddOns\\ElvUI\\Media\\Textures\\Tank.tga", "Interface\\AddOns\\ElvUI\\Media\\Textures\\Healer.tga", "Interface\\AddOns\\ElvUI\\Media\\Textures\\DPS.tga"}
                end
            end
        end
    end
    
    -- r38-release
    if CellDB["revise"] and dbRevision < 38 then
        if CellDB["raidTools"]["pullTimer"][1] == "ERT" then
            CellDB["raidTools"]["pullTimer"][1] = "ExRT"
        end

        for _, layout in pairs(CellDB["layouts"]) do
            if not layout["indicators"][19] or layout["indicators"][19]["indicatorName"] ~= "targetedSpells" then
                tinsert(layout["indicators"], 19, {
                    ["name"] = "Targeted Spells",
                    ["indicatorName"] = "targetedSpells",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["position"] = {"CENTER", "TOPLEFT", 7, -7},
                    ["frameLevel"] = 50,
                    ["size"] = {20, 20},
                    ["border"] = 2,
                    ["spells"] = {},
                    ["glow"] = {"Pixel", {0.95,0.95,0.32,1}, 9, .25, 8, 2},
                    ["font"] = {"Cell ".._G.DEFAULT, 12, "Outline", 2},
                })
            end
        end
    end

    -- r41-release
    if CellDB["revise"] and dbRevision < 41 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][19] and layout["indicators"][19]["indicatorName"] == "targetedSpells" then
                if #layout["indicators"][19]["spells"] == 0 then
                    layout["indicators"][19]["enabled"] = true
                    layout["indicators"][19]["spells"] = {320788, 344496, 319941}
                end
            end
        end
    end

    -- r44-release
    if CellDB["revise"] and dbRevision < 44 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][19] and layout["indicators"][19]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][19]["spells"], 320132) then -- 暗影之怒
                    tinsert(layout["indicators"][19]["spells"], 320132)
                end
                if not F:TContains(layout["indicators"][19]["spells"], 322614) then -- 心灵连接
                    tinsert(layout["indicators"][19]["spells"], 322614)
                end
            end
        end
    end

    -- r46-release
    if CellDB["revise"] and dbRevision < 46 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][13] and layout["indicators"][13]["indicatorName"] == "externalCooldowns" then
                layout["indicators"][13]["orientation"] = "right-to-left"
            end
            if layout["indicators"][14] and layout["indicators"][14]["indicatorName"] == "defensiveCooldowns" then
                layout["indicators"][14]["orientation"] = "left-to-right"
            end
            if layout["indicators"][17] and layout["indicators"][17]["indicatorName"] == "debuffs" then
                layout["indicators"][17]["orientation"] = "left-to-right"
            end
        end

        CellDB["general"]["tooltipsPosition"] = {"BOTTOMLEFT", "Unit Button", "TOPLEFT", 0, 15}
    end

    -- r47-release
    if CellDB["revise"] and dbRevision < 47 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][19] and layout["indicators"][19]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][19]["spells"], 334053) then -- 净化冲击波
                    tinsert(layout["indicators"][19]["spells"], 334053)
                end
            end
        end

        if type(CellDB["appearance"]["highlightSize"]) ~= "number" then
            CellDB["appearance"]["highlightSize"] = 1
        end
        if type(CellDB["appearance"]["outOfRangeAlpha"]) ~= "number" then
            CellDB["appearance"]["outOfRangeAlpha"] = .45
        end
    end

    -- r48-release
    if CellDB["revise"] and dbRevision < 48 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][19] and layout["indicators"][19]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][19]["spells"], 343556) then -- 病态凝视
                    tinsert(layout["indicators"][19]["spells"], 343556)
                end
                if not F:TContains(layout["indicators"][19]["spells"], 320596) then -- 深重呕吐
                    tinsert(layout["indicators"][19]["spells"], 320596)
                end
            end
        end
    end

    -- r49-release
    if CellDB["revise"] and dbRevision < 49 then
        if type(CellDB["appearance"]["barAnimation"]) ~= "string" then
            CellDB["appearance"]["barAnimation"] = "Flash"
        end
    end

    -- r50-release
    if CellDB["revise"] and dbRevision < 50 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- add statusIcon
            if layout["indicators"][4] and layout["indicators"][4]["indicatorName"] ~= "statusIcon" then
                tinsert(layout["indicators"], 4, {
                    ["name"] = "Status Icon",
                    ["indicatorName"] = "statusIcon",
                    ["type"] = "built-in",
                    ["enabled"] = true,
                    ["position"] = {"TOP", "TOP", 0, -3},
                    ["frameLevel"] = 10,
                    ["size"] = {18, 18},
                })
            end

            -- update debuffs
            if layout["indicators"][18] and layout["indicators"][18]["indicatorName"] == "debuffs" then
                if type(layout["indicators"][18]["bigDebuffs"]) ~= "table" then
                    layout["indicators"][18]["bigDebuffs"] = {
                        209858, -- 死疽溃烂
                        46392, -- 专注打击
                    }
                    layout["indicators"][18]["size"] = {layout["indicators"][18]["size"], {17, 17}} -- normalSize, bigSize
                end
            end

            -- add targetCounter
            if (not layout["indicators"][21]) or (layout["indicators"][21] and layout["indicators"][21]["indicatorName"] ~= "targetCounter") then
                tinsert(layout["indicators"], 21, {
                    ["name"] = "Target Counter",
                    ["indicatorName"] = "targetCounter",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["position"] = {"TOP", "TOP", 0, 5},
                    ["frameLevel"] = 15,
                    ["font"] = {"Cell ".._G.DEFAULT, 15, "Outline", 0},
                    ["color"] = {1, .1, .1},
                })
            end
        end
    end
    ]]

    -- r55-release
    if CellDB["revise"] and dbRevision < 55 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- update debuffs
            if layout["indicators"][18] and layout["indicators"][18]["indicatorName"] == "debuffs" then
                --- 焚化者阿寇拉斯
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 355732) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 355732) -- 融化灵魂
                end
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 355738) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 355738) -- 灼热爆破
                end
                -- 凇心之欧罗斯
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 356667) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 356667) -- 刺骨之寒
                end
                -- 刽子手瓦卢斯
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 356925) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 356925) -- 屠戮
                end
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 356923) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 356923) -- 撕裂
                end
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 358973) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 358973) -- 恐惧浪潮
                end
                -- 粉碎者索苟冬
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 355806) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 355806) -- 重压
                end
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 358777) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 358777) -- 痛苦之链
                end
            end
        end
    end

    -- r56-release
    if CellDB["revise"] and dbRevision < 56 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][20] and layout["indicators"][20]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][20]["spells"], 356924) then
                    tinsert(layout["indicators"][20]["spells"], 356924)  -- 屠戮
                end
                if not F:TContains(layout["indicators"][20]["spells"], 356666) then -- 刺骨之寒
                    tinsert(layout["indicators"][20]["spells"], 356666)
                end
                if not F:TContains(layout["indicators"][20]["spells"], 319713) then -- 巨兽奔袭
                    tinsert(layout["indicators"][20]["spells"], 319713)
                end
            end
            if layout["indicators"][18] and layout["indicators"][18]["indicatorName"] == "debuffs" then
                if not F:TContains(layout["indicators"][18]["bigDebuffs"], 240559) then
                    tinsert(layout["indicators"][18]["bigDebuffs"], 240559)  -- 重伤
                end
            end
        end
    end

    -- r57-release
    if CellDB["revise"] and dbRevision < 57 then
        if type(CellDB["raidTools"]["deathReport"]) ~= "table" then
            CellDB["raidTools"]["deathReport"] = {false, 10}
        end
        if type(CellDB["raidTools"]["showBuffTracker"]) ~= "boolean" then
            CellDB["raidTools"]["showBuffTracker"] = false
        end
        if type(CellDB["raidTools"]["buffTrackerPosition"]) ~= "table" then
            CellDB["raidTools"]["buffTrackerPosition"] = {}
        end
    end

    -- r60-release
    if CellDB["revise"] and dbRevision < 60 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][20] and layout["indicators"][20]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][20]["spells"], 338606) then
                    tinsert(layout["indicators"][20]["spells"], 338606) -- 病态凝视
                end
                if not F:TContains(layout["indicators"][20]["spells"], 343556) then
                    tinsert(layout["indicators"][20]["spells"], 343556) -- 病态凝视
                end
            end
            if type(layout["petSize"]) ~= "table" then
                layout["petSize"] = {false, 66, 46}
            end
        end
    end

    -- r61-release
    if CellDB["revise"] and dbRevision < 61 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- rename aggroIndicator
            if layout["indicators"][10] and layout["indicators"][10]["indicatorName"] == "aggroIndicator" then
                layout["indicators"][10]["name"] = "Aggro (blink)"
                layout["indicators"][10]["indicatorName"] = "aggroBlink"
            end
            -- rename aggroBar
            if layout["indicators"][11] and layout["indicators"][11]["indicatorName"] == "aggroBar" then
                layout["indicators"][11]["name"] = "Aggro (bar)"
            end
            -- add aggroBorder
            if layout["indicators"][12] and layout["indicators"][12]["indicatorName"] ~= "aggroBorder" then
                tinsert(layout["indicators"], 12, {
                    ["name"] = "Aggro (border)",
                    ["indicatorName"] = "aggroBorder",
                    ["type"] = "built-in",
                    ["enabled"] = false,
                    ["frameLevel"] = 1,
                    ["thickness"] = 3,
                })
            end
            -- update frameLevel
            for _, indicator in pairs(layout["indicators"]) do
                if indicator["indicatorName"] == "healthText" then
                    indicator["frameLevel"] = 2
                elseif indicator["indicatorName"] == "playerRaidIcon" then
                    indicator["frameLevel"] = 2
                elseif indicator["indicatorName"] == "targetRaidIcon" then
                    indicator["frameLevel"] = 2
                elseif indicator["indicatorName"] == "aggroBlink" then
                    indicator["frameLevel"] = 3
                elseif indicator["indicatorName"] == "shieldBar" then
                    indicator["frameLevel"] = 2
                elseif indicator["indicatorName"] == "tankActiveMitigation" then
                    indicator["frameLevel"] = 2
                elseif indicator["indicatorName"] == "debuffs" then
                    indicator["frameLevel"] = 2
                end
            end
        end
    end

    -- r63-release
    if CellDB["revise"] and dbRevision < 63 then
        -- 起伏机动
        if not F:TContains(CellDB["debuffBlacklist"], 352562) then
            tinsert(CellDB["debuffBlacklist"], 352562)
            Cell.vars.debuffBlacklist = F:ConvertTable(CellDB["debuffBlacklist"])
        end
    end
    
    -- r64-release
    if CellDB["revise"] and dbRevision < 64 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][21] and layout["indicators"][21]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][21]["spells"], 324079) then
                    tinsert(layout["indicators"][21]["spells"], 324079) -- 收割之镰
                end
                if not F:TContains(layout["indicators"][21]["spells"], 317963) then
                    tinsert(layout["indicators"][21]["spells"], 317963) -- 知识烦扰
                end
            end
            if layout["indicators"][19] and layout["indicators"][19]["indicatorName"] == "debuffs" then
                if not F:TContains(layout["indicators"][19]["bigDebuffs"], 240443) then
                    tinsert(layout["indicators"][19]["bigDebuffs"], 240443) -- 爆裂
                end
                if F:TContains(layout["indicators"][19]["bigDebuffs"], 243237) then
                    F:TRemove(layout["indicators"][19]["bigDebuffs"], 243237)
                end
            end
        end
        -- 审判灵魂
        if not F:TContains(CellDB["debuffBlacklist"], 356419) then
            tinsert(CellDB["debuffBlacklist"], 356419)
            Cell.vars.debuffBlacklist = F:ConvertTable(CellDB["debuffBlacklist"])
        end
    end

    -- r65-release
    if CellDB["revise"] and dbRevision < 65 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][21] and layout["indicators"][21]["indicatorName"] == "targetedSpells" then
                if not F:TContains(layout["indicators"][21]["spells"], 333861) then
                    tinsert(layout["indicators"][21]["spells"], 333861) -- 回旋利刃
                end
            end
        end
    end

    -- r66-release
    if CellDB["revise"] and dbRevision < 66 then
        -- always targeting
        if not CellDB["clickCastings"][Cell.vars.playerClass]["alwaysTargeting"] then
            CellDB["clickCastings"][Cell.vars.playerClass]["alwaysTargeting"] = {
                ["common"] = "disabled",
            }
            for sepcIndex = 1, GetNumSpecializationsForClassID(Cell.vars.playerClassID) do
                local specID = GetSpecializationInfoForClassID(Cell.vars.playerClassID, sepcIndex)
                CellDB["clickCastings"][Cell.vars.playerClass]["alwaysTargeting"][specID] = "disabled"
            end
        end
    end

    -- r68-release
    if CellDB["revise"] and dbRevision < 68 then
        if type(CellDB["appearance"]["iconAnimation"]) ~= "string" then
            CellDB["appearance"]["iconAnimation"] = "duration"
        end
    end
    
    -- r69-release
    if CellDB["revise"] and dbRevision < 69 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][20] and layout["indicators"][20]["indicatorName"] == "raidDebuffs" then
                layout["indicators"][20]["num"] = 1
                layout["indicators"][20]["orientation"] = "left-to-right"
            end
        end

        if type(CellDB["appearance"]["bgAlpha"]) ~= "number" then
            CellDB["appearance"]["bgAlpha"] = 1
        end
    end

    -- r70-release
    if CellDB["revise"] and dbRevision < 70 then
        for _, layout in pairs(CellDB["layouts"]) do
            -- check custom indicator
            for i = 23, #layout["indicators"] do
                if layout["indicators"][i]["type"] == "text" then
                    layout["indicators"][i]["showDuration"] = true
                end
            end
        end

        if type(CellDB["appearance"]["barAlpha"]) ~= "number" then
            CellDB["appearance"]["barAlpha"] = 1
        end
        
        if type(CellDB["appearance"]["lossAlpha"]) ~= "number" then
            CellDB["appearance"]["lossAlpha"] = 1
        end

        if type(CellDB["appearance"]["lossColor"]) ~= "table" then
            CellDB["appearance"]["lossColor"] = CellDB["appearance"]["bgColor"]
            CellDB["appearance"]["bgColor"] = nil
        end 

        if type(CellDB["appearance"]["healPrediction"]) ~= "boolean" then
            CellDB["appearance"]["healPrediction"] = true
        end
        if type(CellDB["appearance"]["healAbsorb"]) ~= "boolean" then
            CellDB["appearance"]["healAbsorb"] = true
        end
        if type(CellDB["appearance"]["shield"]) ~= "boolean" then
            CellDB["appearance"]["shield"] = true
        end
        if type(CellDB["appearance"]["overshield"]) ~= "boolean" then
            CellDB["appearance"]["overshield"] = true
        end
    end

    -- r71-release
    if CellDB["revise"] and dbRevision < 71 then
        for _, layout in pairs(CellDB["layouts"]) do
            if layout["indicators"][2] and layout["indicators"][2]["indicatorName"] == "statusText" and not layout["indicators"][2]["colors"] then
                layout["indicators"][2]["colors"] = {
                    ["GHOST"] = {1, 0.19, 0.19},
                    ["DEAD"] = {1, 0.19, 0.19},
                    ["AFK"] = {1, 0.19, 0.19},
                    ["OFFLINE"] = {1, 0.19, 0.19},
                    ["FEIGN"] = {1, 1, 0.12},
                    ["DRINKING"] = {0.12, 0.75, 1},
                    ["PENDING"] = {1, 1, 0.12},
                    ["ACCEPTED"] = {0.12, 1, 0.12},
                    ["DECLINED"] = {1, 0.19, 0.19},
                }
            end
            
            if not layout["powerFilters"] then
                layout["powerFilters"] = {
                    ["DEATHKNIGHT"] = {["TANK"] = true, ["DAMAGER"] = true},
                    ["DEMONHUNTER"] = {["TANK"] = true, ["DAMAGER"] = true},
                    ["DRUID"] = {["TANK"] = true, ["DAMAGER"] = true, ["HEALER"] = true},
                    ["HUNTER"] = true,
                    ["MAGE"] = true,
                    ["MONK"] = {["TANK"] = true, ["DAMAGER"] = true, ["HEALER"] = true},
                    ["PALADIN"] = {["TANK"] = true, ["DAMAGER"] = true, ["HEALER"] = true},
                    ["PRIEST"] = {["DAMAGER"] = true, ["HEALER"] = true},
                    ["ROGUE"] = true,
                    ["SHAMAN"] = {["DAMAGER"] = true, ["HEALER"] = true},
                    ["WARLOCK"] = true,
                    ["WARRIOR"] = {["TANK"] = true, ["DAMAGER"] = true},
                    ["PET"] = true,
                    ["VEHICLE"] = true,
                }
            end
        end
    end

    CellDB["revise"] = Cell.version
end