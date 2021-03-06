local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

-- Below are the Default Settings for NeavUI


-----------------
-- nMedia Options
-----------------	
DB["nMedia"] = {
	border = "Default",
	color = { r = 1, g = 1, b = 1, 1},
	font = "Express Freeway",
	fontSize = 15,	
	warnsound = "Warning",
}

---------------
-- nBuff Options
----------------
DB['nBuff'] = {
	enable = true,
    buffSize = 36,
    buffScale = 1,

    buffFontSize = 14,
    buffCountSize = 16,

    borderBuff = 'Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\BuffOverlay',
    borderDebuff = 'Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\BuffDebuff',

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
DB['nChat'] = {
	enable = true,
    disableFade = false,
    chatOutline = false,
	chatBorder = true,

    enableBottomButton = false, 
    enableHyperlinkTooltip = true, 
    enableBorderColoring = true,
	showInputBoxAbove = true,  -- Show the chat input box above the chat window

    tab = {
        fontSize = 15,
        fontOutline = true, 
        normalColor = { r = 1, g = 1, b = 1 },
        specialColor = { r = 1, g = 0, b = 1 },
        selectedColor = { r = 0, g = 0.75, b = 1 },
    },
}

--------------------
-- nCore Options
--------------------
DB['nCore'] = {
	altbuy = true,
	autogreed = true,
	bubbles = true,
	BlackBook = {
		enable = true,
		AutoFill = true,
		contacts = {},
		recent = {},
		AutoCompleteAlts = true,
		AutoCompleteRecent = true,
		AutoCompleteContacts = true,
		AutoCompleteFriends = true,
		AutoCompleteGuild = true,
		ExcludeRandoms = true,
		DisableBlizzardAutoComplete = false,
		UseAutoComplete = true,
	},
	btsw = true,	
	coords = true,
	cbop = true,
	durability = true,
	-- FacePaint is still a W.I.P.
	facepaint = {
		enable = true,
		custom = {
			gradient = false, 								-- false applies one solid color (class color if class = true, topcolor if not)
			topcolor = { r = 0.9, g = 0.9, b = 0.9 },		-- top gradient color (rgb)
			bottomcolor = {	r = 0.1, g = 0.1, b = 0.1 }, 	-- bottom gradient color (rgb)
			topalpha = 1,									-- top gradient alpha (global if gradient = false)
			bottomalpha = 1,								-- bottom gradient alpha (not used if gradient = false)
		},
	},
	font = true,
	mail = true,
	merchant = {
		enable = true,
		sellMisc = true,
		autoSellGrey = true,
		autoRepair = true,
	},
	omnicc = true,
	quest = {
		enable = true,
		autocomplete = false,	
	},
	quicky = true,
	skins = true,
	spellid = true,
	warning = true,
	watchframe = true,
}

--------------------
-- nData Options
--------------------
DB['nData'] = {
	
	enable = true,
	--shortbar = true,
	databorder = 'Blizzard',
	fontsize = 15,										-- font size for panels.
	fontColor = 'Classcolor',
	bags = 9,                                       	-- show space used in bags on panel.
	system = 0,                                     	-- show total memory and others systems info (FPS/MS) on panel.
	wowtime = 0,                                    	-- show time on panel.
	guild = 4,                                      	-- show number on guildmate connected on panel.
	dur = 8,                                        	-- show your equipment durability on panel.
	friends = 6,                                    	-- show number of friends connected.
	dps_text = 0,                                   	-- show a dps meter on panel.
	hps_text = 0,                                   	-- show a heal meter on panel.
	spec = 5,											-- show your current spec on panel.
	zone = 0,											-- show your current zone on panel.
	coords = 0,											-- show your current coords on panel.
	pro = 7,											-- shows your professions and tradeskills
	stat1 = 1,											-- Stat Based on your Role (Avoidance-Tank, AP-Melee, SP/HP-Caster)
	stat2 = 3,											-- Stat Based on your Role (Armor-Tank, Crit-Melee, Crit-Caster)
	recount = 2,										-- Stat Based on Recount"s DPS
	recountraiddps = false,								-- Enables tracking or Recounts Raid DPS
	calltoarms = 0,										-- Show Current Call to Arms.
	
	battleground = true,                            	-- enable 3 stats in battleground only that replace stat1,stat2,stat3.

	bag = false,										-- True = Open Backpack; False = Open All bags

	-- Clock Settings
	time24 = false,                                  	-- set time to 24h format.
	localtime = true,                              		-- set time to local time instead of server time.	
		
	-- FPS Settings
	fps = {
		enable = true,									-- enable the FPS on the System Tooltip
		-- ONLY ONE OF THESE CAN BE TRUE	
		home = false,									-- Only Show Home Latency
		world = false,									-- Only Show World Latency
		both = true,									-- Show both Home and World Latency
	},
		
	threatbar = true,									-- Enable the threatbar over the Center Panel.

}
------------------
-- nMainbar Options
------------------
DB['nMainbar'] = {
	enable = true,
	
    showPicomenu = true,
    scale = 1,
    hideGryphons = false,       
    shortBar = false,
    skinButton = true,   
	moveableExtraBars = false,      -- Make the pet, possess, shapeshift and totembar moveable, even when the mainmenubar is not "short"	

    button = { 
        showVehicleKeybinds = true,
        showKeybinds = false,
        showMacronames = false,

        countFontsize = 19,
        
        macronameFontsize = 17,
        
        hotkeyFontsize = 18,
    },

    color = {   -- Red, Green, Blue
		Normal = { r = 1, g = 1, b = 1},
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
        mouseover = false,
        alpha = 1,
        orderHorizontal = false,
    },

    multiBarRight = {
        mouseover = false,
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
DB['nMinimap'] = {
	enable = true,
    tab = {
        show = false,
        showAlways = false,

        alphaMouseover = 1,
        alphaNoMouseover = 0.5,

        showBelowMinimap = false,
    },

    mouseover = {
        zoneText = true,
        instanceDifficulty = true,
    },
}

--------------------
-- nPlates Options 
--------------------
DB['nPlates'] = {
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

DB['nPower'] = {
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
DB['nTooltip'] = {
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
	hideRealmText = true,

    healthbar = {
        showHealthValue = true,

        healthFormat = '$cur/$max',			-- Possible: $cur, $max, $deficit, $perc, $smartperc, $smartcolorperc, $colorperc
        healthFullFormat = '$cur',              -- if the tooltip unit has 100% hp 

        fontSize = 15,
        showOutline = true,
        textPos = 'CENTER',                     -- Possible 'TOP' 'BOTTOM' 'CENTER'

        reactionColoring = false,               -- Overrides customColor 
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

DB['nUnitframes'] = {
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
        normalBigSize = 15,
    },

    units = {
        ['player'] = {
            scale = 1.1,
            style = 'NORMAL',                                                               -- 'NORMAL' 'RARE' 'ELITE' 'CUSTOM'
			customTexture = 'Interface\\AddOns\\oUF_Neav\\media\\customFrameTexture',       -- Custom texture if style = 'CUSTOM'
			
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
			showThreat = false,

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
            scale = 1.1,

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
            scale = 1.1,

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
            scale = 1.1,
            disableAura = false,                                                             -- Disable Auras on this unitframe

            mouseoverText = false,
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$perc',
            healthTagFull = '',
       },

        ['focus'] = {
            scale = 1.1,

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
            scale = 1.1,

            mouseoverText = false,
			
			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.			
            healthTag = '$perc',
            healthTagFull = '',
        },

        ['party'] = {
            scale = 1.1,
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
            scale = 1.1,

            mouseoverText = true,

			-- Tags are not Included on the In_Game Options. 
			-- IF YOU WANT TO CHANGE TAGS THEY MUST BE CHANGED HERE IN THE LUA.
            healthTag = '$cur/$max',
            healthTagFull = '$cur',
            powerTag = '$cur/$max',
            powerTagFull = '$cur',
            powerTagNoMana = '$cur',

			position = {
				selfAnchor = 'RIGHT',
				frameParent = UIParent,
				relAnchor = 'RIGHT',
				offSetX = -125,
				offSetY = 125,
			},			

            castbar = {
				show = true,
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
				selfAnchor = 'RIGHT',
				frameParent = UIParent,
				relAnchor = 'RIGHT',
				offSetX = -125,
				offSetY = 125,
			},			

            castbar = {
				color = { r = 1, g = 0, b = 0 },
				
                icon = {
                    size = 22,
                },

            },
            buffList = { -- A whitelist for buffs to display on arena frames
                'Power Word: Shield',
            },			
        },
    },
}

--------------------
-- oUF_NeavRaid Options
--------------------

DB['nRaidframes'] = {
	enable = true,

    font = {
        fontSmallSize = 11,
        fontBigSize = 12,
    },

    units = {
        ['raid'] = {
            showSolo = false,
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
                horizontalOrientation = true,
            },
        },
    },
}