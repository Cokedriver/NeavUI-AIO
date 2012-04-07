local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

-- Below are the Default Settings for NeavUI

---------------
-- nBuff Options
----------------
C['buff'] = {
    buffSize = 36,
    buffScale = 1,
    buffBorderColor = {1, 1, 1}, 

    buffFontSize = 14,
    buffCountSize = 16,

    borderBuff = 'Interface\\AddOns\\NeavUI\\Media\\BuffOverlay',
    borderDebuff = 'Interface\\AddOns\\NeavUI\\Media\\BuffDebuff',

    debuffSize = 36,
    debuffScale = 1,

    debuffFontSize = 14,
    debuffCountSize = 16,

    paddingX = 7,
    paddingY = 7,
    buffPerRow = 8,

    durationFont = 'Fonts\\ARIALN.ttf',
    countFont = 'Fonts\\ARIALN.ttf',
}	

----------------
-- nChat Options
----------------
C['chat'] = {
    disableFade = false,
    chatOutline = false,

    enableBottomButton = false, 
    enableHyperlinkTooltip = false, 
    enableBorderColoring = true,

    tab = {
        fontSize = 15,
        fontOutline = true, 
        normalColor = {1, 1, 1},
        specialColor = {1, 0, 1},
        selectedColor = {0, 0.75, 1},
    },
}
------------------
-- nMainbar Options
------------------
C['mainbar'] = {
    showPicomenu = true,

    button = { 
        showVehicleKeybinds = true,
        showKeybinds = false,
        showMacronames = false,

        countFontsize = 19,
        countFont = 'Fonts\\ARIALN.ttf',
        
        macronameFontsize = 17,
        macronameFont = 'Fonts\\ARIALN.ttf',
        
        hotkeyFontsize = 18,
        hotkeyFont = 'Fonts\\ARIALN.ttf',
    },

    color = {   -- Red, Green, Blue
        Normal = { 1, 1, 1 },
        IsEquipped = { 0, 1, 0 },
        
        OutOfRange = { 0.9, 0, 0 },
        OutOfMana = { 0.3, 0.3, 1 },
        
        NotUsable = { 0.35, 0.35, 0.35 },
        
        HotKeyText = { 0.6, 0.6, 0.6 },
        MacroText = { 1, 1, 1 },
        CountText = { 1, 1, 1 },
    },

    expBar = {
        mouseover = true,
        fontsize = 14,
        font = 'Fonts\\ARIALN.ttf',
    },

    repBar = {
        mouseover = true,
        fontsize = 14,
        font = 'Fonts\\ARIALN.ttf',
    },

    MainMenuBar = {
        scale = 1,
        hideGryphons = false,
        
        shortBar = false,
        skinButton = true,
        
        moveableExtraBars = false,      -- Make the pet, possess, shapeshift and totembar moveable, even when the mainmenubar is not "short"
    },

    vehicleBar = {
        scale = 0.8,
    },

    petBar = {
        mouseover = false,
        scale = 1,
        alpha = 1,
        vertical = false,
    },

    possessBar = {
        scale = 1,
        alpha = 1,
    },

    stanceBar = {
        mouseover = false,
        hide = false,
        scale = 1,
        alpha = 1,
    },

    multiBarLeft = {
        mouseover = true,
        alpha = 1,
        orderHorizontal = false,
    },

    multiBarRight = {
        mouseover = true,
        alpha = 1,
        orderHorizontal = false,
    },

    multiBarBottomLeft = {
        mouseover = false,
        alpha = 1,
    },

    multiBarBottomRight = {
        mouseover = false,
        alpha = 1,
        orderVertical = false,
        verticalPosition = 'LEFT', -- 'LEFT' or 'RIGHT'
    },

    totemManager = {
        scale = 1,
        alpha = 1,
        hideRecallButton = false,
    },
}
	
-------------------
-- nMinimap Options
-------------------
C['minimap'] = {
    tab = {
        show = true,
        showAlways = false,

        alphaMouseover = 1,
        alphaNoMouseover = 0.5,

        showBelowMinimap = false,
    },

    mouseover = {
        zoneText = true,
        instanceDifficulty = false,
    },
}

--------------------
-- nPlates Options 
--------------------
C['plates'] = {
    enableTankMode = true,              -- Color the nameplate threat border green, if you have no aggro
    colorNameWithThreat = true,         -- The name has the same color as the threat of the unit (better visibility)

    showFullHP = true,
    showLevel = true,
    showTargetBorder = true,
    showEliteBorder = true,
    showTotemIcon = true,
    abbrevLongNames = true,
}

--------------------
-- nPower Options 
--------------------

C['power'] = {
    position = {'CENTER', UIParent, 0, -100},
    sizeWidth = 200,
    
    showCombatRegen = true, 

    activeAlpha = 1,
    inactiveAlpha = 0.3,
    emptyAlpha = 0,
    
    valueAbbrev = true,
        
    valueFont = 'Fonts\\ARIALN.ttf',
    valueFontSize = 20,
    valueFontOutline = true,
    valueFontAdjustmentX = 0,

    showSoulshards = true,
    showHolypower = true,
    
    extraFont = 'Fonts\\ARIALN.ttf',                -- The font for the holypower and soulshard number
    extraFontSize = 16,                             -- The fontsiz for the holypower and soulshard number
    extraFontOutline = true,                        
        
    mana = {
        show = true,
    },
    
    energy = {
        show = true,
        showComboPoints = true,
		comboPointsBelow = false,
        
        comboColor = {
            [1] = {r = 1.0, g = 1.0, b = 1.0},
            [2] = {r = 1.0, g = 1.0, b = 1.0},
            [3] = {r = 1.0, g = 1.0, b = 1.0},
            [4] = {r = 0.9, g = 0.7, b = 0.0},
            [5] = {r = 1.0, g = 0.0, b = 0.0},
        },
        
        comboFont = 'Fonts\\ARIALN.ttf',
        comboFontSize = 16,
        comboFontOutline = true,
    },
    
    focus = {
        show = true,
    },
    
    rage = {
        show = true,
    },
    
    rune = {
        show = true,
        showRuneCooldown = false,
        
        runeFont = 'Fonts\\ARIALN.ttf',
        runeFontSize = 16,
        runeFontOutline = true,
    },
}

-------------------
-- nTooltip Options
-------------------
C['tooltip'] = {											
    fontSize = 15,
    fontOutline = false,

    position = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -27.35, 27.35},

    disableFade = false,                        -- Can cause errors or a buggy tooltip!
    showOnMouseover = false,

    reactionBorderColor = true,
    itemqualityBorderColor = true,

    abbrevRealmNames = false, 
    showPlayerTitles = true,
    showUnitRole = true,
    showPVPIcons = false,                       -- Show pvp icons instead of just a prefix
    showMouseoverTarget = true,
    showItemLevel = true,

    healthbar = {
        showHealthValue = false,

        healthFormat = '$cur / $max',           -- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = '$cur',              -- if the tooltip unit has 100% hp 

        fontSize = 13,
        font = 'Fonts\\ARIALN.ttf',
        showOutline = true,
        textPos = 'CENTER',                     -- Possible 'TOP' 'BOTTOM' 'CENTER'

        reactionColoring = true,               -- Overrides customColor 
        customColor = {
            apply = false, 
            r = 0, 
            g = 1, 
            b = 1
        } 
    },		
}

--------------------
-- oUF_Neav Options
--------------------

--[[

    The 'Tag-System'
        Possible: 
            $cur                - Shows the current hp of the unit > 53,4k
            $max                - Shows the maximum hp of the unit > 105,3k
            $deficit            - Shows the deficit value > -10k
            $perc               - Show the percent > 100%
            $smartperc          - Show the percent without the '%' > 100
            $colorperc          - Same as $perc, but color the number depended on the percent of the unit. Green if full, red if low percent
            $smartcolorperc     - Same as above, but without the '%'
            $alt                - Only for power value, shows the current alternative power of the unit (like Cho'gall fight)

    Its possible to add hex color
        Example:
            |cffff0000 YOUTAGHERE |r

            -->   '$cur / $perc |cffff0000$deficit|r'

        So you have a red deficit value
--]]

C['unitframes'] = {
    show = {
        castbars = true,
        pvpicons = true,
        classPortraits = false,
        threeDPortraits = false,                                                            -- 3DPortraits; Overrides classPortraits
        disableCooldown = false,                                                            -- Disable custom cooldown text to use addons like omnicc
        portraitTimer = true,
    },

    media = {
        border = 'Interface\\AddOns\\NeavUI\\Media\\borderTexture',                       -- Buffborder Texture
        statusbar = 'Interface\\AddOns\\NeavUI\\Media\\statusbarTexture',                 -- Statusbar texture
    },

    font = {
        normal = 'Interface\\AddOns\\NeavUI\\Media\\fontSmall.ttf',                       -- General font for all other  
        normalSize = 13,

        normalBig = 'Interface\\AddOns\\NeavUI\\Media\\fontThick.ttf',                    -- Name font
        normalBigSize = 14,
    },

    units = {
        ['player'] = {
            scale = 1.193,
            style = 'NORMAL',                                                               -- 'NORMAL' 'RARE' 'ELITE' 'CUSTOM'
            customTexture = 'Interface\\AddOns\\NeavUI\\Media\\customFrameTexture',       -- Custom texture if style = 'CUSTOM'

            mouseoverText = false,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showVengeance = false,                                                          -- Attention: vengeance and swingtimer will overlap eachother, 
            showSwingTimer = false,                                                         -- Change the pos in the NeavUI file if you want both
            showStatusFlash = true,
            showCombatFeedback = false,

            position = {'TOPLEFT', UIParent, 34, -30},

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                showLatency = true, 
                showSafezone = true,
                safezoneColor = {1, 0, 1},

                classcolor = true,
                color = {1, 0.7, 0},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 200},
            },
        },

        ['pet'] = {
            scale = 1.193,

            auraSize = 22,

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            position = {43, -20},

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                color = {0, 0.65, 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

                position = {'TOP', oUF_Neav_Player, 'BOTTOM', 0, -50},

                ignoreSpells = true,                                                        -- Hides castbar for spells listed in 'ignoreList'
                ignoreList = {
                    3110,   -- firebolt (imp)
                    31707,  -- waterbolt (water elemental)
                },
            },
        },

        ['target'] = {
            scale = 1.193,

            numBuffs = 20,
            numDebuffs = 20,
            colorPlayerDebuffsOnly = true,
            showAllTimers = false,                                                          -- If false, only the player debuffs have timer
            disableAura = false,                                                            -- Disable Auras on this unitframe

            showComboPoints = true,
            showComboPointsAsNumber = false,
            numComboPointsColor = {0.9, 0, 0},                                              -- Textcolor of the combopoints if showComboPointsAsNumber = true

            mouseoverText = false,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showCombatFeedback = false,

            position = {'TOPLEFT', UIParent, 300, -30},

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                color = {0.9, 0.1, 0.1},
                interruptColor = {1, 0, 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = false,
                },

                position = {'BOTTOM', UIParent, 'BOTTOM', 0, 380},
            },
        },

        ['targettarget'] = {
            scale = 1.193,
            disableAura = false,                                                             -- Disable Auras on this unitframe

            mouseoverText = false,
            healthTag = '$perc',
            healthTagFull = '',
       },

        ['focus'] = {
            scale = 1.193,

            numDebuffs = 6,
            
            mouseoverText = false,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            showCombatFeedback = false,

            enableFocusToggleKeybind = true,
            focusToggleKey = 'type4',                                                       -- type1, type2 (mousebutton 1 or 2, 3, 4, 5 etc. works too)

            castbar = {
                show = true, 

                width = 176,
                height = 19,
                scale = 0.93,

                color = {0, 0.65, 1},
                interruptColor = {1, 0, 1},

                icon = {
                    show = false,
                    position = 'LEFT',   -- 'LEFT' or 'RIGHT'
                    positionOutside = true,
                },
            },
        },

        ['focustarget'] = {
            scale = 1.193,

            mouseoverText = false,
            healthTag = '$perc',
            healthTagFull = '',
        },

        ['party'] = {
            scale = 1.11,
            show = false,
            hideInRaid = true,

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPLEFT', UIParent, 25, -200},
        },

        ['boss'] = {
            scale = 1,

            mouseoverText = true,
            healthTag = '$cur - $perc',
            healthTagFull = '$cur',
            powerTag = '$cur',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -50, -250},

            castbar = {
                color = {1, 0, 0},

                icon = {
                    size = 22,
                    show = false,                       
                    position = 'LEFT'   -- 'LEFT' or 'RIGHT' 
                },
            },
        },

        ['arena'] = {
            show = true,
            scale = 1,

            auraSize = 22,

            mouseoverText = true,
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            position = {'TOPRIGHT', UIParent, 'TOPRIGHT', -80, -300},

            castbar = {
                icon = {
                    size = 22,
                },

                color = {1, 0, 0},
            },
        },
    },
}

--------------------
-- oUF_NeavRaid Options
--------------------

C['raidframes'] = {
	enable = false,
    media = {
        statusbar = 'Interface\\AddOns\\NeavUI\\Media\\statusbarTexture',                 -- Health- and Powerbar texture
    },

    font = {
        fontSmall = 'Interface\\AddOns\\NeavUI\\Media\\fontSmall.ttf',                    -- Name font
        fontSmallSize = 11,

        fontBig = 'Interface\\AddOns\\NeavUI\\Media\\fontThick.ttf',                      -- Health, dead/ghost/offline etc. font
        fontBigSize = 12,
    },

    units = {
        ['raid'] = {
            showSolo = true,
            showParty = false,

            nameLength = 4,

            width = 42,
            height = 40,
            scale = 1.1, 

            layout = {
                frameSpacing = 7,
                numGroups = 8,

                initialAnchor = 'TOPLEFT',                                                  -- 'TOPLEFT' 'BOTTOMLEFT' 'TOPRIGHT' 'BOTTOMRIGHT'
                orientation = 'HORIZONTAL',                                                 -- 'VERTICAL' 'HORIZONTAL'
            },

            smoothUpdates = true,                                                           -- Enable smooth updates for all bars
            showThreatText = false,                                                         -- Show a red 'AGGRO' text on the raidframes in addition to the glow
            showRolePrefix = false,                                                         -- A simple role abbrev..tanks = '>'..healer = '+'..dds = '-'
            showNotHereTimer = true,                                                        -- A afk and offline timer
            showMainTankIcon = true,                                                        -- A little shield on the top of a raidframe if the unit is marked as maintank
            showResurrectText = true,                                                       -- Not working atm. just a placeholder
            showMouseoverHighlight = true,

            showTargetBorder = true,                                                        -- Ahows a little border on the raid/party frame if this unit is your target
            targetBorderColor = {1, 1, 1},

            iconSize = 22,                                                                  -- The size of the debufficon
            indicatorSize = 7,

            horizontalHealthBars = false,
            deficitThreshold = 0.95,

            manabar = {
                show = true,
                horizontalOrientation = false,
            },
        },
    },
}