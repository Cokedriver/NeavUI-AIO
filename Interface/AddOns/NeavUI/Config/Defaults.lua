local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

-- Below are the Default Settings for NeavUI

DB["media"] = {
	font = "Fonts\\ARIALN.ttf",
	fontSmall = "Interface\\AddOns\\NeavUI\\Media\\fontSmall.ttf",
	fontThick = "Interface\\AddOns\\NeavUI\\Media\\fontThick.ttf",	
	fontVisitor = "Interface\\AddOns\\NeavUI\\Media\\fontVisitor.ttf",	
	fontNumber = "Interface\\AddOns\\NeavUI\\Media\\fontNumber.ttf",	
}

---------------
-- nBuff Options
----------------
DB['buff'] = {
	enable = true,
    buffSize = 36,
    buffScale = 1,
    buffBorderColor = {r = 1, g = 1, b = 1}, 

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
}	

----------------
-- nChat Options
----------------
DB['chat'] = {
	enable = true,
    disableFade = false,
    chatOutline = false,
	chatBorder = true,
	chatBorderClassColor = true,

    enableBottomButton = false, 
    enableHyperlinkTooltip = false, 
    enableBorderColoring = true,

    tab = {
        fontSize = 15,
        fontOutline = true, 
        normalColor = { r = 1, g = 1, b = 1 },
        specialColor = { r = 1, g = 0, b = 1 },
        selectedColor = { r = 0, g = 0.75, b = 1 },
    },
}

--------------------
-- nGeneral Options
--------------------
DB['general'] = {
	altbuy = true,
	autogreed = true,
	bubbles = true,
	coords = true,
	durability = true,
	mail = true,
	omnicc = true,
	quicky = true,
	skins = true,
	spellid = true,
	warning = true,
	watchframe = true,
}
------------------
-- nMainbar Options
------------------
DB['mainbar'] = {
	enable = true,
	
    showPicomenu = true,

    button = { 
        showVehicleKeybinds = true,
        showKeybinds = false,
        showMacronames = false,

        countFontsize = 19,
        
        macronameFontsize = 17,
        
        hotkeyFontsize = 18,
    },

    color = {   -- Red, Green, Blue
        Normal = { r = 1, g = 1, b = 1 },
        IsEquipped = { r = 0, g = 1, b = 0 },
        
        OutOfRange = { r = 0.9, g = 0, b = 0 },
        OutOfMana = { r = 0.3, g = 0.3, b = 1 },
        
        NotUsable = { r = 0.35, g = 0.35, b = 0.35 },
        
        HotKeyText = { r = 0.6, g = 0.6, b = 0.6 },
        MacroText = { r = 1, g = 1, b = 1 },
        CountText = { r = 1, g = 1, b = 1 },
    },

    expBar = {
        mouseover = true,
        fontsize = 14,
    },

    repBar = {
        mouseover = true,
        fontsize = 14,
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
DB['minimap'] = {
	enable = true,
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
DB['plates'] = {
	enable = true,
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

DB['power'] = {
	enable = true,
    position = {
		selfAnchor = 'CENTER',
		frameParent = UIParent,
		offSetX = 0,
		offSetY = -100
	},
    sizeWidth = 200,
    
    showCombatRegen = true, 

    activeAlpha = 1,
    inactiveAlpha = 0.3,
    emptyAlpha = 0,
    
    valueAbbrev = true,
        
    valueFontSize = 20,
    valueFontOutline = true,
    valueFontAdjustmentX = 0,

    showSoulshards = true,
    showHolypower = true,
    showMana = true,
	showFocus = true,
	showRage = true,
	
    extraFontSize = 16,                             -- The fontsiz for the holypower and soulshard number
    extraFontOutline = true,                        
        
    
    energy = {
        show = true,
        showComboPoints = true,
		comboPointsBelow = false,
        
        comboFontSize = 16,
        comboFontOutline = true,
    },
    
    
    rune = {
        show = true,
        showRuneCooldown = false,
       
        runeFontSize = 16,
        runeFontOutline = true,
    },
}

-------------------
-- nTooltip Options
-------------------
DB['tooltip'] = {
	enable = true,
    fontSize = 15,
    fontOutline = false,

    position = {
		selfAnchor = 'BOTTOMRIGHT',
		frameParent = UIParent,
		relAnchor = 'BOTTOMRIGHT',
		offSetX = -27.35,
		offSetY = 27.35,
	},

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

        healthFormat = '$cur/$max',			-- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = '$cur',              -- if the tooltip unit has 100% hp 

        fontSize = 13,
        showOutline = true,
        textPos = 'CENTER',                     -- Possible 'TOP' 'BOTTOM' 'CENTER'

        reactionColoring = true,               -- Overrides customColor 
        customColor = {
            apply = false, 
            color = {r = 0, g = 1, b = 1},
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

DB['unitframes'] = {
	enable = true,
    show = {
        castbars = true,
        pvpicons = true,
        classPortraits = false,
        threeDPortraits = false,                                                            -- 3DPortraits; Overrides classPortraits
        disableCooldown = false,                                                            -- Disable custom cooldown text to use addons like omnicc
        portraitTimer = true,
    },

    font = { 
        normalSize = 13,
        normalBigSize = 14,
    },

    units = {
        ['player'] = {
            scale = 1.193,
            style = 'NORMAL',                                                               -- 'NORMAL' 'RARE' 'ELITE' 'CUSTOM'

            mouseoverText = false,
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showVengeance = false,                                                          -- Attention: vengeance and swingtimer will overlap eachother, 
            showSwingTimer = false,                                                         -- Change the pos in the NeavUI file if you want both
            showStatusFlash = true,
            showCombatFeedback = false,

            position = {
				selfAnchor ='TOPLEFT',
				frameParent = UIParent,
				offSetX = 34, 
				offSetY = -30,
			},

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                showLatency = true, 
                showSafezone = true,
                safezoneColor = { r = 1, g = 0, b = 1 },

                classcolor = true,
                color = { r = 1, g = 0.7, b = 0 },

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

				position = {
					selfAnchor = 'BOTTOM',
					frameParent = UIParent,
					relAnchor = 'BOTTOM',
					offSetX = 0,
					offSetY = 200,
				},				
            },
        },

        ['pet'] = {
            scale = 1.193,

            auraSize = 22,
	
            mouseoverText = true,
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            position = {
				offSetX = 43,
				offSetY = -20
			},

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                color = { r = 0, g = 0.65, b = 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = true,
                },

				position = {
					selfAnchor = 'TOP',
					frameParent = oUF_Neav_Player,
					relAnchor = 'BOTTOM',
					offSetX = 0,
					offSetY = -50,
				},				

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
            numComboPointsColor = { r = 0.9, g = 0, b = 0 },                                              -- Textcolor of the combopoints if showComboPointsAsNumber = true

            mouseoverText = false,

			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.			
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showCombatFeedback = false,

			position = {
				selfAnchor = 'TOPLEFT',
				frameParent = UIParent,
				offSetX = 300,
				offSetY = -30,
			},			

            castbar = {
                show = true, 

                width = 220,
                height = 19,
                scale = 0.93,

                color = { r = 0.9, g = 0.1, b = 0.1},
                interruptColor = { r = 1, g = 0, b = 1},

                icon = {
                    show = false,
                    position = 'LEFT',                                                      -- 'LEFT' 'RIGHT'
                    positionOutside = false,
                },

				position = {
					selfAnchor = 'BOTTOM',
					frameParent = UIParent,
					relAnchor = 'BOTTOM',
					offSetX = 0,
					offSetY = 380,
				},				
            },
        },

        ['targettarget'] = {
            scale = 1.193,
            disableAura = false,                                                             -- Disable Auras on this unitframe

            mouseoverText = false,
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$perc',
            healthTagFull = '',
       },

        ['focus'] = {
            scale = 1.193,

            numDebuffs = 6,
            
            mouseoverText = false,

			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

            showPowerPercent = false,

            showCombatFeedback = false,

            enableFocusToggleKeybind = true,
            focusToggleKey = 'type4',             		-- type1, type2 (mousebutton 1 or 2, 3, 4, 5 etc. works too) 
			
            castbar = {
                show = true, 

                width = 176,
                height = 19,
                scale = 0.93,

                color = { r = 0, g = 0.65, b = 1},
                interruptColor = { r = 1, g = 0, b = 1 },

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
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.			
            healthTag = '$perc',
            healthTagFull = '',
        },

        ['party'] = {
            scale = 1.11,
            show = false,
            hideInRaid = true,

            mouseoverText = true,

			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

			position = {
				selfAnchor = 'TOPLEFT',
				frameParent = UIParent,
				offSetX = 25,
				offSetY = -200,
			},			
        },

        ['boss'] = {
            scale = 1,

            mouseoverText = true,

			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

			position = {
				selfAnchor = 'TOPRIGHT',
				frameParent = UIParent,
				relAnchor = 'TOPRIGHT',
				offSetX = -50,
				offSetY = -250,
			},			

            castbar = {
                color = { r = 1, g = 0, b = 0 },

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
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

			position = {
				selfAnchor = 'TOPRIGHT',
				frameParent = UIParent,
				relAnchor = 'TOPRIGHT',
				offSetX = -80,
				offSetY = -300,
			},			

            castbar = {
				color = { r = 1, g = 0, b = 0 },
				
                icon = {
                    size = 22,
                },

            },
        },
    },
}

--------------------
-- oUF_NeavRaid Options
--------------------

DB['raidframes'] = {
	enable = false,

    font = {
        fontSmallSize = 11,
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
            targetBorderColor = { r = 1, g = 1, b = 1 },

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