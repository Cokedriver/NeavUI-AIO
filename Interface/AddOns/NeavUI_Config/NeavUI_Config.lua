local NeavUIConfig = LibStub("AceAddon-3.0"):NewAddon("NeavUIConfig", "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local db
local defaults

local L = setmetatable({}, { __index = function(t,k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end })

function NeavUIConfig:LoadDefaults()
	local N, _, DB = unpack(NeavUI)
	--Defaults
	defaults = {
		profile = {
			nGeneral = DB["nGeneral"],			
			nBuff = DB["nBuff"],
			nChat = DB["nChat"],
			nCore = DB["nCore"],
			nData = DB["nData"],			
			nMainbar = DB["nMainbar"],
			nMedia = DB["nMedia"],
			nMinimap = DB["nMinimap"],			
			nPlates = DB["nPlates"],
			nPower = DB["nPower"],			
			nTooltip = DB["nTooltip"],
			nUnitframes = DB["nUnitframes"],
			nRaidframes = DB["nRaidframes"],			
		},
		global = {
			BlackBook = {
				alts = {},
			},
		},		
	}
end	


function NeavUIConfig:OnInitialize()
	NeavUIConfig:RegisterChatCommand("ui", "ShowConfig")
	NeavUIConfig:RegisterChatCommand("neavui", "ShowConfig")
	
	self.OnInitialize = nil
end

function NeavUIConfig:ShowConfig(arg)
	InterfaceOptionsFrame_OpenToCategory(self.profilesFrame)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

function NeavUIConfig:Load()
	self:LoadDefaults()

	-- Create savedvariables
	self.db = LibStub("AceDB-3.0"):New("NeavUIConfig", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile
	
	self:SetupOptions()
end

function NeavUIConfig:OnProfileChanged(event, database, newProfileKey)
	StaticPopup_Show("CFG_RELOAD")
end

function NeavUIConfig:SetupOptions()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("NeavUIConfig", self.GenerateOptions)
	--Create Profiles Table
	self.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("NeavUIProfiles", self.profileOptions)
	
	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrame = ACD3:AddToBlizOptions("NeavUIConfig", "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r|cffffd200UI|r", nil)
	--self.optionsFrame = ACD3:AddToBlizOptions("NeavUIProfiles", L["|cffCC3333n|r|cffffd200Profiles|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI")	
	self.SetupOptions = nil
end

function NeavUIConfig.GenerateOptions()
	if NeavUIConfig.noconfig then assert(false, NeavUIConfig.noconfig) end
	if not NeavUIConfig.Options then
		NeavUIConfig.GenerateOptionsInternal()
		NeavUIConfig.GenerateOptionsInternal = nil
	end
	return NeavUIConfig.Options
end

function NeavUIConfig.GenerateOptionsInternal()
	local N, C, DB = unpack(NeavUI)

	StaticPopupDialogs["CFG_RELOAD"] = {
		text = L["One or more of the changes you have made require a UI Reload."],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}	

	-----------------------
	-- Options Order Chart
	-----------------------
	-- toggle = 1
	-- select = 2
	-- color = 3
	-- range = 4
	-- group = 5	
	
	NeavUIConfig.Options = {
		type = "group",
		name = "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI",
		handler = NeavUI,
		--childGroups = "tree",
		args = {
			nGeneral = {
				order = 0,
				type = "group",
				name = L["|cffCC3333n|rThanks"],
				args = {
					text0 = {
						order = 1,
						type = "description",
						fontSize = "large",
						name = L["|cffCC3333Special Thanks goes to:|r"],				
					},
					text1 = {
						order = 2,
						type = "description",
						fontSize = "medium",
						name = L["Haste, kerrang, zork, Tuller, and many more for their great AddOns."],				
					},
					sep1 = {
						order = 3,
						type = "description",
						name = " ",						
					},
					text2 = {
						order = 4,
						type = "description",
						fontSize = "large",
						name = L["|cffCC3333Commands:|r"],				
					},					
					text3 = {
						order = 5,
						type = "description",
						fontSize = "medium",
						name = L["/neavrt to move the raid frames."],				
					},
					text4 = {
						order = 6,
						type = "description",
						fontSize = "medium",
						name = L["/wm, /worldmarkers, /rm or /raidmarkers to show world raid markers."],				
					},
					text5 = {
						order = 7,
						type = "description",
						fontSize = "medium",
						name = L["/rolecheck or /rcheck to do a role check."],				
					},
				},
			},
			nMedia = {				
				name = L["|cffCC3333n|rMedia"],
				desc = L[""],
				order = 1,				
				type = "group",
				get = function(info) return db.nMedia[ info[#info] ] end,
				set = function(info, value) db.nMedia[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------				
					font = {						
						name = L["Font Style"],
						desc = L[""],
						order = 2,
						type = 'select',
						dialogControl = 'LSM30_Font', --Select your widget here						
						values = AceGUIWidgetLSMlists.font,	
					},
					fontSize = {						
						name = L["Font Size"],
						desc = L[""],
						order = 4,
						type = "range",
						min = 0, max = 30, step = 1,
					},				
					border = {						
						name = L["Beauty Border Color"],
						desc = L[""],
						order = 4,
						type = 'select',					
						values = N.bordercolor,	
					},
					color = {
						name = L["Custom Border Color"],
						desc = L[""],
						order = 3,
						type = "color",						
						get = function(info)
							local mc = db.nMedia[ info[#info] ]
							if mc then
								return mc.r, mc.g, mc.b
							end
						end,
						set = function(info, r, g, b)
							db.nMedia[ info[#info] ] = {}
							local mc = db.nMedia[ info[#info] ]
							if mc then
								mc.r, mc.g, mc.b = r, g, b
								StaticPopup_Show("CFG_RELOAD")
							end
						end,										
					},
					warnsound = {
						order = 2,
						name = L["Warning Sound"],
						desc = L[""],
						disabled = function() return not db.nCore.selfbuffs.enable end,
						type = "select",
						dialogControl = 'LSM30_Sound', --Select your widget here
						values = AceGUIWidgetLSMlists.sound,
					},					
				},
			},			
			nCore = {
				order = 2,
				type = "group",
				name = L["|cffCC3333n|rCore"],
				desc = L[""],
				get = function(info) return db.nCore[ info[#info] ] end,
				set = function(info, value) db.nCore[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------				
					altbuy = {
						order = 1,
						name = L["Alt Buy"],
						desc = L[""],
						type = "toggle",							
					},
					autogreed = {
						order = 1,
						name = L["Autogreed"],
						desc = L[""],
						type = "toggle",						
					},
					bubbles = {
						order = 1,
						name = L["Bubbles"],
						desc = L[""],
						type = "toggle",						
					},
					BlackBook = {								
						name = L["|cffCC3333n|rBlackBook"],
						desc = L[""],
						order = 5,							
						type = "group",								
						guiInline = true,
						get = function(info) return db.nCore.BlackBook[ info[#info] ] end,
						set = function(info, value) db.nCore.BlackBook[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
						args = {					
							enable = {
								name = L["Enable"],
								desc = L[""],
								order = 0,
								type = "toggle",								
							},
							AutoFill = {										
								name = L["Auto Fill"],
								desc = L[""],
								order = 1,
								disabled = function() return not db.nCore.BlackBook.enable end,
								type = "toggle",										
							},
							AutoCompleteAlts = {									
								name = L["Auto Complete Alts"],
								desc = L[""],
								order = 1,
								disabled = function() return not db.nCore.BlackBook.enable end,
								type = "toggle",																				
							},
							AutoCompleteRecent = {										
								name = L["Auto Complete Recent"],
								desc = L[""],
								order = 1,
								disabled = function() return not db.nCore.BlackBook.enable end,
								type = "toggle",										
							},
							AutoCompleteContacts = {										
								name = L["Auto Complete Contacts"],
								desc = L[""],
								order = 1,
								disabled = function() return not db.nCore.BlackBook.enable end,
								type = "toggle",										
							},
							AutoCompleteFriends = {
								order = 1,
								name = L["Auto Complete Friends"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.BlackBook.enable end,
							},
							AutoCompleteGuild = {
								order = 1,
								name = L["Auto Complete Guild"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.BlackBook.enable end,
							},
							ExcludeRandoms = {
								order = 1,
								name = L["Exclude Randoms"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.BlackBook.enable end,
							},
							DisableBlizzardAutoComplete = {
								order = 1,
								name = L["Disable Blizzard Auto Complete"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.BlackBook.enable end,
							},
							UseAutoComplete = {
								order = 1,
								name = L["Use Auto Complete"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.BlackBook.enable end,
							},
						},
					},					
					coords = {
						order = 1,
						name = L["Coords"],
						desc = L[""],
						type = "toggle",
					},
					btsw = {
						type = "toggle",
						order = 1,						
						name = L["Bigger Tradeskill Window"],
						desc = L["Enables a Double Windows Tradeskill Window."],							
					},
					cbop = {
						type = "toggle",
						order = 1,						
						name = L["Craftable Bind On Pickup Warning"],
						desc = L["Enables a Warning Popup anytime you craft a BOP item."],							
					},					
					durability = {
						order = 1,
						name = L["Durability"],
						desc = L[""],
						type = "toggle",
					},					
					mail = {
						order = 1,
						name = L["Mail"],
						desc = L[""],
						type = "toggle",
					},
					merchant = {
						order = 5,
						type = "group",
						name = L["|cffCC3333n|rMerchant"],
						desc = L[""],
						guiInline = true,
						get = function(info) return db.nCore.merchant[ info[#info] ] end,
						set = function(info, value) db.nCore.merchant[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							enable = {
								type = "toggle",
								order = 0,
								name = L["Enable |cffCC3333n|rMerchant"],
								desc = L[""],							
							},
							autoRepair = {
								type = "toggle",
								order = 1,
								name = L["Auto Repair"],
								desc = L[""],
								disabled = function() return not db.nCore.merchant.enable end,
							},
							autoSellGrey = {
								type = "toggle",
								order = 1,
								name = L["Sell Grays"],
								desc = L[""],
								disabled = function() return not db.nCore.merchant.enable end,
							},					
							sellMisc = {
								type = "toggle",
								order = 1,
								name = L["Sell Misc Items"],
								desc = L[""],
								disabled = function() return not db.nCore.merchant.enable end,
							},
						},
					},					
					omnicc = {
						order = 1,
						name = L["OmniCC"],
						desc = L[""],
						type = "toggle",
					},
					quest = {
						order = 5,
						type = "group",
						name = L["|cffCC3333n|rQuest"],
						desc = L[""],
						guiInline = true,
						get = function(info) return db.nCore.quest[ info[#info] ] end,
						set = function(info, value) db.nCore.quest[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							enable = {
								order = 0,
								name = L["Enable |cffCC3333n|rQuest"],
								desc = L[""],
								type = "toggle",
							},					
							autocomplete = {
								order = 1,
								name = L["Autocomplete"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nCore.quest.enable end,
							},
						},
					},					
					quicky = {
						order = 1,
						name = L["Quicky"],
						desc = L[""],
						type = "toggle",
					},					
					skins = {
						order = 1,
						name = L["Skins"],
						desc = L[""],
						type = "toggle",
					},
					spellid = {
						order = 1,
						name = L["SpellID"],
						desc = L[""],
						type = "toggle",
					},
					warning = {
						order = 1,
						name = L["Warning"],
						desc = L[""],
						type = "toggle",
					},
					watchframe = {
						order = 1,
						name = L["Watchframe"],
						desc = L[""],
						type = "toggle",
					},					
				},
			},
			nBuff = {
				order = 3,
				type = "group",
				name = L["|cffCC3333n|rBuff"],
				desc = L[""],
				get = function(info) return db.nBuff[ info[#info] ] end,
				set = function(info, value) db.nBuff[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------							
					enable = {
						order = 0,
						name = L["Enable |cffCC3333 n|rBuff."],
						desc = L[""],
						type = "toggle",
					},				
					buffSize = {
						order = 4,
						name = L["Buff Size"],
						desc = L[""],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					buffScale = {
						order = 4,
						name = L["Buff Scale"],
						desc = L[""],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					buffFontSize = {
						order = 4,
						name = L["Buff Font Size"],
						desc = L[""],
						type = "range",
						min = 8, max = 25, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					buffCountSize = {
						order = 4,
						name = L["Buff Count Size"],
						desc = L[""],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffSize = {
						order = 4,
						name = L["DeBuff Size"],
						desc = L[""],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffScale = {
						order = 4,
						name = L["DeBuff Scale"],
						desc = L[""],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffFontSize = {
						order = 4,
						name = L["DeBuff Font Size"],
						desc = L[""],
						type = "range",
						min = 8, max = 25, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffCountSize = {
						order = 4,
						name = L["DeBuff Count Size"],
						desc = L[""],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					paddingX = {
						order = 4,
						name = L["Padding X"],
						desc = L[""],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					paddingY = {
						order = 4,
						name = L["Padding Y"],
						desc = L[""],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},						
					buffPerRow = {
						order = 4,
						name = L["Buffs Per Row"],
						desc = L[""],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},					
				},
			},			
			nChat = {
				order = 4,
				type = "group",
				name = L["|cffCC3333n|rChat"],
				desc = L[""],
				get = function(info) return db.nChat[ info[#info] ] end,
				set = function(info, value) db.nChat[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------							
					enable = {
						order = 0,
						name = L["Enable |cffCC3333n|rChat"],
						desc = L[""],
						type = "toggle",
					},					
					disableFade = {
						order = 1,
						name = L["Disable Fade"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					chatOutline = {
						order = 1,
						name = L["Chat Outline"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					chatBorder = {
						order = 1,
						name = L["Border"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					enableBottomButton = {
						order = 1,
						name = L["Bottom Button"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					enableHyperlinkTooltip = {
						order = 1,
						name = L["Hyplerlink Tooltip"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					enableBorderColoring = {
						order = 1,
						name = L["Channel Border Coloring"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					showInputBoxAbove = {
						order = 1,
						name = L["Editbox Above Chat Window"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},					
					tab = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Tab"],
						desc = L[""],
						disabled = function() return not db.nChat.enable end,
						get = function(info) return db.nChat.tab[ info[#info] ] end,
						set = function(info, value) db.nChat.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------											
							fontOutline = {
								order = 1,
								name = L["Font Outline"],
								desc = L[""],
								type = "toggle",								
							},
							fontSize = {
								type = "range",
								width = "double",
								order = 4,
								name = L["Font Scale"],
								desc = L[""],
								type = "range",
								min = 9, max = 20, step = 1,									
							},							
							normalColor = {
								order = 3,
								type = "color",
								name = L["Tab Normal Color"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tnc = db.nChat.tab[ info[#info] ]
									if tnc then
										return tnc.r, tnc.g, tnc.b
									end
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tnc = db.nChat.tab[ info[#info] ]
									if tnc then
										tnc.r, tnc.g, tnc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},
							specialColor = {
								order = 3,
								type = "color",
								name = L["Tab Special Color"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tsc = db.nChat.tab[ info[#info] ]
									if tsc then
										return tsc.r, tsc.g, tsc.b
									end
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tsc = db.nChat.tab[ info[#info] ]
									if tsc then
										tsc.r, tsc.g, tsc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end	
								end,					
							},
							selectedColor = {
								order = 3,
								type = "color",
								name = L["Tab Selected Color"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tscc = db.nChat.tab[ info[#info] ]
									if tscc then
										return tscc.r, tscc.g, tscc.b
									end
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tscc = db.nChat.tab[ info[#info] ]
									if tscc then
										tscc.r, tscc.g, tscc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},							
						},
					},
				},
			},
			nData = {
				order = 5,
				type = "group",
				name = L["|cffCC3333n|rData"],
				desc = L[""],
				--childGroups = "tree",
				get = function(info) return db.nData[ info[#info] ] end,
				set = function(info, value) db.nData[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------				
					enable = {
						order = 0,
						name = L["Enable |cffCC3333n|rData"],
						desc = L[""],
						type = "toggle",
					},					
					time24 = {
						order = 1,
						type = "toggle",
						name = L["24-Hour Time"],
						desc = L[""],
							disabled = function() return not db.nData.enable end,					
					},					
					bag = {
						order = 1,
						type = "toggle",
						name = L["Bag Open"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,						
					},				
					battleground = {
						order = 1,
						type = "toggle",
						name = L["Battleground Text"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,						
					},					
					localtime = {
						order = 1,
						type = "toggle",
						name = L["Local Time"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,						
					},
					recountraiddps = {
						order = 1,
						type = "toggle",
						name = L["Recount Raid DPS"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,								
					},						
					threatbar = {
						order = 1,
						type = "toggle",
						name = L["Threatbar"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,						
					},					
					databorder = {
						order = 2,
						name = L["Datapanel Border Style"],
						desc = L[""],
						disabled = function() return not db.nData.enable end,
						type = "select",
						style = "radio",
						values = N.border;
					},									
					DataGroup = {
						order = 5,
						type = "group",
						guiInline = true,
						name = L["Text Options"],
						disabled = function() return not db.nData.enable end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							fontsize = {
								order = 4,
								name = L["Text Scale"],
								desc = L[""],
								type = "range",
								min = 9, max = 25, step = 1,
								disabled = function() return not db.nData.enable end,						
							},						
							bags = {
								order = 4,
								type = "range",
								name = L["Bags"],
								desc = L["Display ammount of bag space"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							calltoarms = {
								order = 4,
								type = "range",
								name = L["Call to Arms"],
								desc = L["Display the active roles that will recieve a reward for completing a random dungeon"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,																
							},
							coords = {
								order = 4,
								type = "range",
								name = L["Coordinates"],
								desc = L["Display Player's Coordinates"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,																
							},						
							dps_text = {
								order = 4,
								type = "range",
								name = L["DPS"],
								desc = L["Display ammount of DPS"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,																
							},						
							dur = {
								order = 4,
								type = "range",
								name = L["Durability"],
								desc = L["Display your current durability"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,
							},
							friends = {
								order = 4,
								type = "range",
								name = L["Friends"],
								desc = L["Display current online friends"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							guild = {
								order = 4,
								type = "range",
								name = L["Guild"],
								desc = L["Display current online people in guild"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							hps_text = {
								order = 4,
								type = "range",
								name = L["HPS"],
								desc = L["Display ammount of HPS"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							pro = {
								order = 4,
								type = "range",
								name = L["Professions"],
								desc = L["Display Professions"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							recount = {
								order = 4,
								type = "range",
								name = L["Recount"],
								desc = L["Display Recount's DPS (RECOUNT MUST BE INSTALLED)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,								
							},							
							spec = {
								order = 4,
								type = "range",
								name = L["Talent Spec"],
								desc = L["Display current spec"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							stat1 = {
								order = 4,
								type = "range",
								name = L["Stat #1"],
								desc = L["Display stat based on your role (Avoidance-Tank, AP-Melee, SP/HP-Caster)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,			
							},							
							stat2 = {
								order = 4,
								type = "range",
								name = L["Stat #2"],
								desc = L["Display stat based on your role (Armor-Tank, Crit-Melee, Crit-Caster)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,						
							},
							system = {
								order = 4,
								type = "range",
								name = L["System"],
								desc = L["Display FPS and Latency"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							wowtime = {
								order = 4,
								type = "range",
								name = L["Time"],
								desc = L["Display current time"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							zone = {
								order = 4,
								type = "range",
								name = L["Zone"],
								desc = L["Display Player's Current Zone."]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
						},
					},
				},
			},								
			nMainbar = {
				order = 6,
				type = "group",
				name = L["|cffCC3333n|rMainbar"],
				desc = L[""],
				get = function(info) return db.nMainbar[ info[#info] ] end,
				set = function(info, value) db.nMainbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------						
					enable = {
						type = "toggle",
						order = 0,
						name = L["Enable |cffCC3333n|rMainbar"],
						desc = L[""],							
					},
					showPicomenu = {
						type = "toggle",
						order = 1,
						name = L["Pico Menu"],
						disabled = function() return not db.nMainbar.enable end,
						desc = L[""],							
					},
					scale = {
						order = 4,
						name = L["Scale"],
						desc = L[""],
						type = "range",
						width = "double",
						min = 0.5, max = 2, step = 0.5,
						disabled = function() return not db.nMainbar.enable end,
					},
					hideGryphons = {
						order = 1,
						name = L["Hide Gryphons"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nMainbar.enable end,
					},
					shortBar = {
						order = 1,
						name = L["Shortbar"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nMainbar.enable end,
					},
					skinButton = {
						order = 1,
						name = L["Skin Buttons"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nMainbar.enable end,
					},
					moveableExtraBars = {
						order = 1,
						name = L["Moveable Extra Bars"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nMainbar.enable end,
					},					
					button = {
						type = "group",
						order = 5,
						name = L["Buttons"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.button[ info[#info] ] end,
						set = function(info, value) db.nMainbar.button[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							showVehicleKeybinds = {
								order = 1,
								name = L["Vehicle Keybinds"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							showKeybinds = {
								order = 1,
								name = L["Keybinds"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},	
							showMacronames = {
								order = 1,
								name = L["Macronames"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},								
							countFontsize = {
								order = 4,
								name = L["Count Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
							macronameFontsize = {
								order = 4,
								name = L["Macroname Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
							hotkeyFontsize = {
								order = 4,
								name = L["Hot Key Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
						},						
					},
					color = {
						type = "group",
						order = 5,
						name = L["Color"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.color[ info[#info] ] end,
						set = function(info, value) db.nMainbar.color[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							Normal = {
								order = 3,
								type = "color",
								name = L["Normal"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local nc = db.nMainbar.color[ info[#info] ]
									if nc then
										return nc.r, nc.g, nc.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local nc = db.nMainbar.color[ info[#info] ]
									if nc then
										nc.r, nc.g, nc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},
							IsEquipped = {
								order = 3,
								type = "color",
								name = L["Is Equipped"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local iec = db.nMainbar.color[ info[#info] ]
									if iec then
										return iec.r, iec.g, iec.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local iec = db.nMainbar.color[ info[#info] ]
									if iec then
										iec.r, iec.g, iec.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},
							OutOfRange = {
								order = 3,
								type = "color",
								name = L["Out of Range"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local oor = db.nMainbar.color[ info[#info] ]
									if oor then
										return oor.r, oor.g, oor.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local oor = db.nMainbar.color[ info[#info] ]
									if oor then
										oor.r, oor.g, oor.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end
								end,					
							},
							OutOfMana = {
								order = 3,
								type = "color",
								name = L["Out of Mana"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local oom = db.nMainbar.color[ info[#info] ]
									if oom then
										return oom.r, oom.g, oom.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local oom = db.nMainbar.color[ info[#info] ]
									if oom then
										oom.r, oom.g, oom.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},
							NotUsable = {
								order = 3,
								type = "color",
								name = L["Not Usable"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local nu = db.nMainbar.color[ info[#info] ]
									if nu then
										return nu.r, nu.g, nu.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local nu = db.nMainbar.color[ info[#info] ]
									if nu then
										nu.r, nu.g, nu.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end
								end,					
							},
							HotKeyText = {
								order = 3,
								type = "color",
								name = L["Hot Key Text"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local hkt = db.nMainbar.color[ info[#info] ]
									if hkt then
										return hkt.r, hkt.g, hkt.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local hkt = db.nMainbar.color[ info[#info] ]
									if hkt then
										hkt.r, hkt.g, hkt.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end
								end,					
							},
							MacroText = {
								order = 3,
								type = "color",
								name = L["Macro Text"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local mt = db.nMainbar.color[ info[#info] ]
									if mt then
										return mt.r, mt.g, mt.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local mt = db.nMainbar.color[ info[#info] ]
									if mt then
										mt.r, mt.g, mt.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end	
								end,					
							},
							CountText = {
								order = 3,
								type = "color",
								name = L["Count Text"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local ct = db.nMainbar.color[ info[#info] ]
									if ct then
										return ct.r, ct.g, ct.b
									end
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local ct = db.nMainbar.color[ info[#info] ]
									if ct then
										ct.r, ct.g, ct.b = r, g, b
										StaticPopup_Show("CFG_RELOAD") 
									end
								end,					
							},
						},
					},
					expBar = {
						type = "group",
						order = 5,
						name = L["Experiance Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.expBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.expBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------												
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							fontsize = {
								order = 4,
								name = L["Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					repBar = {
						type = "group",
						order = 5,
						name = L["Reputation Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.repBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.repBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------												
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							fontsize = {
								order = 4,
								name = L["Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					vehicleBar = {
						type = "group",
						order = 5,
						name = L["Vehicle Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.vehicleBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.vehicleBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------												
							scale = {
								order = 4,
								name = L["Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					petBar = {
						type = "group",
						order = 5,
						name = L["Pet Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.petBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.petBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							vertical = {
								order = 1,
								name = L["Vertical"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							scale = {
								order = 4,
								name = L["Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					possessBar = {
						type = "group",
						order = 5,
						name = L["Possess Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.possessBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.possessBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							scale = {
								order = 4,
								name = L["Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					stanceBar = {
						type = "group",
						order = 5,
						name = L["Stance Bar"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.stanceBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.stanceBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							hide = {
								order = 1,
								name = L["Hide"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							scale = {
								order = 4,
								name = L["Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarLeft = {
						type = "group",
						order = 5,
						name = L["Multi Bar Left"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarLeft[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderHorizontal = {
								order = 1,
								name = L["Order Horizontal"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarRight = {
						type = "group",
						order = 5,
						name = L["Multi Bar Right"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarRight[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderHorizontal = {
								order = 1,
								name = L["Order Horizontal"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 5,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarBottomLeft = {
						type = "group",
						order = 5,
						name = L["Multi Bar Bottom Left"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarBottomLeft[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarBottomLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarBottomRight = {
						type = "group",
						order = 5,
						name = L["Multi Bar Bottom Right"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarBottomRight[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarBottomRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderVertical = {
								order = 1,
								name = L["Order Vertical"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},
							verticalPosition = {
								order = 4,
								name = L["Vertical Position"],
								desc = L[""],
								disabled = function() return not db.nMainbar.enable end,
								type = "select",
								values = N.LorR;
							},							
						},						
					},
					totemManager = {
						type = "group",
						order = 5,
						name = L["Totem Manager"],
						desc = L[""],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.totemManager[ info[#info] ] end,
						set = function(info, value) db.nMainbar.totemManager[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------						
							hideRecallButton = {
								order = 1,
								name = L["Hide Recall Button"],
								desc = L[""],
								
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							scale = {
								order = 4,
								name = L["Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},								
							alpha = {
								order = 4,
								name = L["Alpha"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},					
				},
			},
			nMinimap = {
				order = 7,
				type = "group",
				name = L["|cffCC3333n|rMinimap"],
				desc = L[""],
				get = function(info) return db.nMinimap[ info[#info] ] end,
				set = function(info, value) db.nMinimap[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------							
					enable = {
						type = "toggle",
						order = 0,
						name = L["Enable |cffCC3333n|rMinimap"],
						desc = L[""],							
					},
					tab = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Popup Tab"],
						desc = L[""],
						disabled = function() return not db.nMinimap.enable end,
						get = function(info) return db.nMinimap.tab[ info[#info] ] end,
						set = function(info, value) db.nMinimap.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							show = {
								type = "toggle",
								order = 1,
								name = L["Show"],
								desc = L[""],
								disabled = function() return not db.nMinimap.enable end,
							},
							showAlways = {
								type = "toggle",
								order = 1,
								name = L["Show Always"],
								desc = L[""],
								disabled = function() return not db.nMinimap.enable end,
							},
							showBelowMinimap = {
								type = "toggle",
								order = 1,
								name = L["Show Below Minimap"],
								desc = L[""],
								disabled = function() return not db.nMinimap.enable end,
							},					
							alphaMouseover= {
								order = 4,
								name = L["Alpha Mouseover"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMinimap.enable end,
							},
							alphaNoMouseover= {
								order = 4,
								name = L["Alpha No Mouseover"],
								desc = L[""],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMinimap.enable end,
							},
						},
					},
					mouseover = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Mouseover"],
						desc = L[""],
						disabled = function() return not db.nMinimap.enable end,
						get = function(info) return db.nMinimap.mouseover[ info[#info] ] end,
						set = function(info, value) db.nMinimap.mouseover[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							zoneText = {
								type = "toggle",
								order = 1,
								name = L["Zone Text"],
								desc = L[""],
								disabled = function() return not db.nMinimap.enable end,
							},
							instanceDifficulty = {
								type = "toggle",
								order = 1,
								name = L["Instance Difficulty"],
								desc = L[""],
								disabled = function() return not db.nMinimap.enable end,
							},
						},
					},
				},
			},				
			nPlates = {
				order = 8,
				type = "group",
				name = L["|cffCC3333n|rPlates"],
				desc = L[""],
				get = function(info) return db.nPlates[ info[#info] ] end,
				set = function(info, value) db.nPlates[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------								
					enable = {
						type = "toggle",
						order = 0,
						name = L["Enable |cffCC3333n|rPlates"],
						desc = L[""],							
					},
					enableTankMode = {
						type = "toggle",
						order = 1,
						name = L["Enable Tank Mode"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},				
					colorNameWithThreat = {
						type = "toggle",
						order = 1,
						name = L["Color Name With Threat"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},
					showFullHP = {
						type = "toggle",
						order = 1,
						name = L["Show Full HP"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},	
					showLevel = {
						type = "toggle",
						order = 1,
						name = L["Show Level"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},	
					showTargetBorder = {
						type = "toggle",
						order = 1,
						name = L["Show Target Border"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},	
					showEliteBorder = {
						type = "toggle",
						order = 1,
						name = L["Show Elite Border"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},	
					showTotemIcon = {
						type = "toggle",
						order = 1,
						name = L["Show Totem Icon"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},
					abbrevLongNames = {
						type = "toggle",
						order = 1,
						name = L["Abbrev Long Names"],
						desc = L[""],
						disabled = function() return not db.nPlates.enable end,
					},						
				},
			},
			nPower = {
				order = 9,
				type = "group",
				name = L["|cffCC3333n|rPower"],
				desc = L[""],
				get = function(info) return db.nPower[ info[#info] ] end,
				set = function(info, value) db.nPower[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------								
					enable = {
						order = 0,
						name = L["Enable |cffCC3333n|rPower"],
						desc = L[""],
						type = "toggle",							
					},					
					showCombatRegen = {
						order = 1,
						name = L["Show Combat Regen"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},				
					showSoulshards = {
						order = 1,
						name = L["Show Soulshards"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showHolypower = {
						order = 1,
						name = L["Show Holypower"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showMana = {
						order = 1,
						name = L["Show Mana"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showFocus = {
						order = 1,
						name = L["Show Focus"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showRage = {
						order = 1,
						name = L["Show Rage"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					valueAbbrev = {
						order = 1,
						name = L["Value Abbrev"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					valueFontOutline = {
						order = 1,
						name = L["Value Font Outline"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					sizeWidth= {
						order = 4,
						name = L["Size Width"],
						desc = L[""],
						type = "range",
						min = 50, max = 350, step = 25,
						disabled = function() return not db.nPower.enable end,
					},					
					activeAlpha = {
						order = 4,
						name = L["Active Alpha"],
						desc = L[""],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},
					inactiveAlpha = {
						order = 4,
						name = L["In Active Alpha"],
						desc = L[""],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},
					emptyAlpha = {
						order = 14,
						name = L["Empty Alpha"],
						desc = L[""],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},										
					valueFontSize = {
						order = 4,
						name = L["Value Font Size"],
						desc = L[""],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.nPower.enable end,
					},	
					valueFontAdjustmentX = {
						order = 4,
						name = L["Value Font Adjustment X"],
						desc = L[""],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not db.nPower.enable end,
					},
					position = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["|cffCC3333n|rPower Position"],
						desc = L[""],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.position[ info[#info] ] end,
						set = function(info, value) db.nPower.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								desc = L[""],
								disabled = function() return not db.nPower.enable end,
								type = "select",
								values = N.regions;
							},
							offSetX= {
								order = 4,
								name = L["Off Set X"],
								desc = L[""],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
							offSetY= {
								order = 4,
								name = L["Off Set Y"],
								desc = L[""],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
						},
					},					
					energy = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Energy"],
						desc = L[""],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.energy[ info[#info] ] end,
						set = function(info, value) db.nPower.energy[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							show = {
								order = 1,
								name = L["Show"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							showComboPoints = {
								order = 1,
								name = L["Show Combo Points"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							comboPointsBelow = {
								order = 1,
								name = L["Combo Points Below"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},							
							comboFontOutline = {
								order = 1,
								name = L["Combo Font Outline"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							comboFontSize = {
								order = 4,
								name = L["Combo Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
						},
					},
					rune = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Rune"],
						desc = L[""],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.rune[ info[#info] ] end,
						set = function(info, value) db.nPower.rune[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							show = {
								order = 1,
								name = L["Show"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							showRuneCooldown = {
								order = 1,
								name = L["Show Rune Cooldown"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},							
							runeFontOutline = {
								order = 1,
								name = L["Rune Font Outline"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							runeFontSize= {
								order = 4,
								name = L["Rune Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nPower.enable end,
							},						
						},
					},					
				},
			},			
			nTooltip = {
				order = 10,
				type = "group",
				name = L["|cffCC3333n|rTooltip"],
				desc = L[""],
				get = function(info) return db.nTooltip[ info[#info] ] end,
				set = function(info, value) db.nTooltip[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------								
					enable = {
						order = 0,
						name = L["Enable |cffCC3333n|rTooltip"],
						desc = L[""],
						type = "toggle",
					},
					fontOutline = {
						order = 1,
						name = L["Font Outline"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},					
					fontSize= {
						order = 4,
						name = L["Font Size"],
						desc = L[""],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.nTooltip.enable end,
					},
					position = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Position"],
						desc = L[""],	
						disabled = function() return not db.nTooltip.enable end,
						get = function(info) return db.nTooltip.position[ info[#info] ] end,
						set = function(info, value) db.nTooltip.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								desc = L[""],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},
							relAnchor = {
								order = 2,
								name = L["Rel Anchor"],
								desc = L[""],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},							
							offSetX= {
								order = 4,
								name = L["Off Set X"],
								desc = L[""],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},
							offSetY= {
								order = 4,
								name = L["Off Set Y"],
								desc = L[""],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},
						},
					},					
					disableFade = {
						order = 1,
						name = L["Disable Fade"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showOnMouseover = {
						order = 1,
						name = L["Show On Mouseover"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					reactionBorderColor = {
						order = 1,
						name = L["Reaction Border Color"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					itemqualityBorderColor = {
						order = 1,
						name = L["Item Quality Border Color"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					abbrevRealmNames = {
						order = 1,
						name = L["Abbrev Realm Names"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showPlayerTitles = {
						order = 1,
						name = L["Show Player Titles"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showUnitRole = {
						order = 1,
						name = L["Show Unit Role"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},					
					showPVPIcons = {
						order = 1,
						name = L["Show PVP Icons"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showMouseoverTarget = {
						order = 1,
						name = L["Mouseover Target"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showItemLevel = {
						order = 1,
						name = L["Item Level"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					hideRealmText = {
						order = 1,
						name = L["Hide Realm Text"],
						desc = L[""],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},					
					healthbar = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Healthbar"],
						desc = L[""],
						disabled = function() return not db.nTooltip.enable end,
						get = function(info) return db.nTooltip.healthbar[ info[#info] ] end,
						set = function(info, value) db.nTooltip.healthbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							showOutline = {
								order = 1,
								name = L["Font Outline"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nTooltip.enable end,
							},
							reactionColoring = {
								order = 1,
								name = L["Reaction Coloring"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nTooltip.enable end,
							},							
							showHealthValue = {
								order = 1,
								name = L["Health Value"],
								desc = L[""],
								type = "toggle",
								
								disabled = function() return not db.nTooltip.enable end,
							},
							healthFormat = {
								order = 2,
								name = L["Health Format 1"],
								desc = L["."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.healthFormat;
							},
							healthFullFormat = {
								order = 2,
								name = L["Health Full Format"],
								desc = L[""],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.healthTag;
							},
							textPos = {
								order = 2,
								name = L["Text Position"],
								desc = L[""],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},													
							fontSize= {
								order = 4,
								name = L["Font Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},							
							customColor = {
								type = "group",
								order = 5,
								guiInline = true,
								name = L["Healthbar Custom Color"],
								desc = L[""],
								disabled = function() return not db.nTooltip.enable end,
								get = function(info) return db.nTooltip.healthbar.customColor[ info[#info] ] end,
								set = function(info, value) db.nTooltip.healthbar.customColor[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									apply = {
										order = 1,
										name = L["Apply Custom Color"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nTooltip.enable end,
									},
									color = {
										order = 3,
										type = "color",
										name = L["Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nTooltip.healthbar.customColor.apply or not db.nTooltip.enable end,
										get = function(info)
											local hcc = db.nTooltip.healthbar.customColor[ info[#info] ]
											if hcc then
												return hcc.r, hcc.g, hcc.b
											end
										end,
										set = function(info, r, g, b)
											db.nTooltip.healthbar.customColor[ info[#info] ] = {}
											local hcc = db.nTooltip.healthbar.customColor[ info[#info] ]
											if hcc then
												hcc.r, hcc.g, hcc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
								},
							},							
						},
					},					
				},
			},
			nUnitframes = {
				order = 11,
				type = "group",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r"],
				width = "full",
				desc = L[""],
				get = function(info) return db.nUnitframes[ info[#info] ] end,
				set = function(info, value) db.nUnitframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,	
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------					
					enable = {
						order = 0,
						name = L["Enable oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r"],
						desc = L[""],
						type = "toggle",
					},
					show = {
						type = "group",
						order = 5,
						name = L["Show"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.show[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.show[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							castbars = {
								order = 1,
								name = L["Castbars"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							pvpicons = {
								order = 1,
								name = L["PvP Icons"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							classPortraits = {
								order = 1,
								name = L["Class Portraits"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							threeDPortraits = {
								order = 1,
								name = L["3D Portraits"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableCooldown = {
								order = 1,
								name = L["Disable Cooldown"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							portraitTimer = {
								order = 1,
								name = L["Portrait Timer"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showThreat = {
								order = 1,
								name = L["Threat Glow"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},							
						},
					},
					font = {
						type = "group",
						guiInline = true,
						order = 5,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Font"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.font[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							normalSize= {
								order = 4,
								name = L["Normal Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							normalBigSize= {
								order = 4,
								name = L["Normal Big Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},					
					player = {
						type = "group",
						order = 5,
						name = L["Player"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.player[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.player[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							scale= {
								order = 4,
								name = L["Player Frame Scale"],
								desc = L[""],
								type = "range",								
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							style = {
								order = 2,
								name = L["Player Frame Style"],
								desc = L[""],
								disabled = function() return not db.nUnitframes.enable end,
								type = "select",
								style = "radio",
								values = N.style;
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showVengeance = {
								order = 1,
								name = L["Show Vengeance"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showSwingTimer = {
								order = 1,
								name = L["Show Swing Timer"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showStatusFlash = {
								order = 1,
								name = L["Show Status Flash"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 1,
								name = L["Show Combat Feedback"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Player Frame Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.player.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.player.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},									
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 5,
								name = L["Player Castbar"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.player.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.player.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show Player Castbar"],
										desc = L[""],
										type = "toggle",
										
										disabled = function() return not db.nUnitframes.enable end,
									},
									showLatency = {
										order = 1,
										name = L["Show Latency"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									showSafezone = {
										order = 1,
										name = L["Show Safe Zone"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									classcolor = {
										order = 1,
										name = L["Castbar Class Color"],
										desc = L[""],
										type = "toggle",
										width = "full",
										disabled = function() return not db.nUnitframes.enable end,
									},									
									safezoneColor = {
										order = 3,
										type = "color",										
										name = L["Safe Zone Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.player.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local szc = db.nUnitframes.units.player.castbar[ info[#info] ]
											if szc then
												return szc.r, szc.g, szc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.player.castbar[ info[#info] ] = {}
											local szc = db.nUnitframes.units.player.castbar[ info[#info] ]
											if szc then
												szc.r, szc.g, szc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},											
									color = {
										order = 3,
										type = "color",
										name = L["Castbar Custom Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.player.castbar.show or not db.nUnitframes.enable or db.nUnitframes.units.player.castbar.classcolor end,
										get = function(info)
											local cc = db.nUnitframes.units.player.castbar[ info[#info] ]
											if cc then
												return cc.r, cc.g, cc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.player.castbar[ info[#info] ] = {}
											local cc = db.nUnitframes.units.player.castbar[ info[#info] ]
											if cc then
												cc.r, cc.g, cc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									width= {
										order = 4,
										name = L["Castbar Width"],
										desc = L[""],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 4,
										name = L["Castbar Height"],
										desc = L[""],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 4,
										name = L["Castbar Scale"],
										desc = L[""],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},									
									icon = {
										type = "group",
										order = 5,
										name = L["Castbar Icon"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.player.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.player.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											show = {
												order = 1,
												name = L["Show Castbar Icon"],
												desc = L[""],
												type = "toggle",
												width = "double",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 1,
												name = L["Position Icon Outside"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 2,
												name = L["Icon Position"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												style = "radio",
												values = N.LorR;
											},
										},
									},
									position = {
										type = "group",
										order = 5,
										name = L["Player Castbar Position"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.player.castbar.position[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.player.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											selfAnchor = {
												order = 2,
												name = L["Self Anchor"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 2,
												name = L["Rel Anchor"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},											
											offSetX = {
												order = 4,
												name = L["Off Set X"],
												desc = L[""],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												desc = L[""],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
										},
									},
								},
							},
						},
					},
					pet = {
						type = "group",
						order = 5,
						name = L["Pet"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.pet[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.pet[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------										
							scale= {
								order = 4,
								name = L["Pet Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							auraSize= {
								order = 4,
								name = L["Aura Size"],
								desc = L[""],
								type = "range",
								min = 10, max = 40, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showPowerPercent = {
								order = 1,
								name = L["Show Power Percent"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Pet Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.pet.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.pet.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 5,
								name = L["Pet Castbar"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.pet.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.pet.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show Pet Castbar"],
										desc = L[""],
										type = "toggle",
										
										disabled = function() return not db.nUnitframes.enable end,
									},
									width= {
										order = 4,
										name = L["Pet Castbar Width"],
										desc = L[""],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 4,
										name = L["Pet Castbar Height"],
										desc = L[""],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 4,
										name = L["Pet Castbar Scale"],
										desc = L[""],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},
									color = {
										order = 3,
										type = "color",
										name = L["Pet Castbar Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.pet.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local pcc = db.nUnitframes.units.pet.castbar[ info[#info] ]
											if pcc then
												return pcc.r, pcc.g, pcc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.pet.castbar[ info[#info] ] = {}
											local pcc = db.nUnitframes.units.pet.castbar[ info[#info] ]
											if pcc then
												pcc.r, pcc.g, pcc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									icon = {
										type = "group",
										order = 5,
										name = L["Castbar Icon"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.pet.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.pet.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											show = {
												order = 1,
												name = L["Show Pet Frame Castbar Icon"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 1,
												name = L["Position Icon Outside"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 2,
												name = L["Icon Position"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.LorR;
											},
										},
									},
									position = {
										type = "group",
										order = 5,
										name = L["Pet Castbar Position"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.pet.castbar.position[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.pet.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											selfAnchor = {
												order = 2,
												name = L["Self Anchor"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 2,
												name = L["Rel Anchor"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},							
											offSetX = {
												order = 4,
												name = L["Off Set X"],
												desc = L[""],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												desc = L[""],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
										},
									},
								},
							},
							ignoreSpells = {
								order = 1,
								name = L["Ignore Spells"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					target = {
						type = "group",
						order = 5,
						name = L["Target"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.target[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.target[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------															
							scale= {
								order = 4,
								name = L["Target Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numBuffs= {
								order = 4,
								name = L["Number of Buffs"],
								desc = L[""],
								type = "range",
								min = 0, max = 8, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numDebuffs= {
								order = 4,
								name = L["Number of Debuffs"],
								desc = L[""],
								type = "range",
								min = 0, max = 8, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							colorPlayerDebuffsOnly = {
								order = 1,
								name = L["Color Player Debuffs Only"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showAllTimers = {
								order = 1,
								name = L["Show All Timers"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableAura = {
								order = 1,
								name = L["Disable Aura"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showComboPoints = {
								order = 1,
								name = L["Show Combo Points"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showComboPointsAsNumber = {
								order = 1,
								name = L["Show Combo Points As Number"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							numComboPointsColor = {
								order = 3,
								type = "color",
								name = L["Number Combo Points Color"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info)
									local ncpc = db.nUnitframes.units.target[ info[#info] ]
									if ncpc then
										return ncpc.r, ncpc.g, ncpc.b
									end
								end,
								set = function(info, r, g, b)
									db.nUnitframes.units.target[ info[#info] ] = {}
									local ncpc = db.nUnitframes.units.target[ info[#info] ]
									if ncpc then
										ncpc.r, ncpc.g, ncpc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end
								end,					
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 1,
								name = L["Show Combat Feedback"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							icon = {
								type = "group",
								order = 5,
								name = L["Castbar Icon"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.target.castbar.icon[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.target.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show Target Castbar Icon"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									positionOutside = {
										order = 1,
										name = L["Position Icon Outside"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									position = {
										order = 2,
										name = L["Icon Position"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.LorR;
									},
								},
							},
							position = {
								type = "group",
								order = 5,
								name = L["Target Castbar Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.target.castbar.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.target.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 2,
										name = L["Rel Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},							
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
						},
					},
					targettarget = {
						type = "group",
						order = 5,
						name = L["Target of Target"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.targettarget[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.targettarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------																
							scale= {
								order = 4,
								name = L["Target of Target Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableAura = {
								order = 1,
								name = L["Disable Aura"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					focus = {
						type = "group",
						order = 5,
						name = L["Focus"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.focus[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.focus[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------															
							scale= {
								order = 4,
								name = L["Focus Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numDebuffs= {
								order = 4,
								name = L["Number of Debuffs"],
								desc = L[""],
								type = "range",
								min = 0, max = 10, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showPowerPercent = {
								order = 1,
								name = L["Show Power Percent"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 1,
								name = L["Show Combat Feedback"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							enableFocusToggleKeybind = {
								order = 1,
								name = L["Enable Focus Toggle Keybind"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							focusToggleKey = {
								order = 2,
								name = L["Focus Toggle Key"],
								desc = L[""],
								disabled = function() return not db.nUnitframes.enable end,
								type = "select",
								values = N.type;
							},
							castbar = {
								type = "group",
								order = 5,
								name = L["Focus Castbar"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.focus.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.focus.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show Focus Castbar"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									width= {
										order = 4,
										name = L["Focus Castbar Width"],
										desc = L[""],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 4,
										name = L["Focus Castbar Height"],
										desc = L[""],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 4,
										name = L["Focus Castbar Scale"],
										desc = L[""],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},
									color = {
										order = 3,
										type = "color",
										name = L["Focus Castbar Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.focus.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local fcc = db.nUnitframes.units.focus.castbar[ info[#info] ]
											if fcc then
												return fcc.r, fcc.g, fcc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.focus.castbar[ info[#info] ] = {}
											local fcc = db.nUnitframes.units.focus.castbar[ info[#info] ]
											if fcc then
												fcc.r, fcc.g, fcc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									interruptColor = {
										order = 3,
										type = "color",
										name = L["Focus Interrupt Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.focus.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local fic = db.nUnitframes.units.focus.castbar[ info[#info] ]
											if fic then
												return fic.r, fic.g, fic.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.focus.castbar[ info[#info] ] = {}
											local fic = db.nUnitframes.units.focus.castbar[ info[#info] ]
											if fic then
												fic.r, fic.g, fic.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									icon = {
										type = "group",
										order = 5,
										name = L["Castbar Icon"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.focus.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.focus.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											show = {
												order = 1,
												name = L["Show Icon"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 1,
												name = L["Position Outside"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 2,
												name = L["Icon Position"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.LorR;
											},
										},
									},
								},
							},
						},
					},
					focustarget = {
						type = "group",
						order = 5,
						name = L["Focus Target"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.focustarget[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.focustarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------															
							scale= {
								order = 4,
								name = L["Focus Target Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					party = {
						type = "group",
						order = 5,
						name = L["Party"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.party[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.party[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------															
							scale= {
								order = 4,
								name = L["Party Frame Scale"],
								desc = L[""],
								type = "range",					
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							show = {
								order = 1,
								name = L["Show"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							hideInRaid = {
								order = 1,
								name = L["Hide In Raid"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Party Frame Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.party.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.party.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},							
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
						},
					},
					boss = {
						type = "group",
						order = 5,
						name = L["Boss"],
						desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.boss[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.boss[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------																
							scale= {
								order = 4,
								name = L["Boss Frame Scale"],
								desc = L[""],
								type = "range",
								
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Boss Frame Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.boss.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.boss.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 2,
										name = L["Rel Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},											
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 5,
								name = L["Boss Castbar"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.boss.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.boss.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									color = {
										order = 3,
										type = "color",
										name = L["Castbar Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info)
											local bcc = db.nUnitframes.units.boss.castbar[ info[#info] ]
											if bcc then
												return bcc.r, bcc.g, bcc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.boss.castbar[ info[#info] ] = {}
											local bcc = db.nUnitframes.units.boss.castbar[ info[#info] ]
											if bcc then
												bcc.r, bcc.g, bcc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									icon = {
										type = "group",
										order = 5,
										name = L["Castbar Icon"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.boss.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.boss.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											show = {
												order = 1,
												name = L["Show Icon"],
												desc = L[""],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											size = {
												order = 4,
												name = L["Icon Size"],
												desc = L[""],
												type = "range",
												min = 8, max = 50, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 2,
												name = L["Icon Position"],
												desc = L[""],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.LorR;
											},
										},
									},
								},
							},
						},
					},
					arena = {
						type = "group",
						order = 5,
						name = L["Arena"],
						desc = L[""],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.arena[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.arena[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							show = {
								order = 1,
								name = L["Show Arena Frames"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},									
							scale= {
								order = 4,
								name = L["Arena Frame Scale"],
								desc = L[""],
								type = "range",
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							auraSize= {
								order = 4,
								name = L["Aura Size"],
								desc = L[""],
								type = "range",								
								min = 5, max = 50, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 1,
								name = L["Mouseover Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Arena Frame Position"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.arena.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.arena.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 2,
										name = L["Rel Anchor"],
										desc = L[""],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},											
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										desc = L[""],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 5,
								name = L["Arena Castbar"],
								desc = L[""],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.arena.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.arena.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show Castbar"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},									
									color = {
										order = 3,
										type = "color",
										name = L["Castbar Color"],
										desc = L[""],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.arena.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local acc = db.nUnitframes.units.arena.castbar[ info[#info] ]
											if acc then
												return acc.r, acc.g, acc.b
											end
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.arena.castbar[ info[#info] ] = {}
											local acc = db.nUnitframes.units.arena.castbar[ info[#info] ]
											if acc then
												acc.r, acc.g, acc.b = r, g, b
												StaticPopup_Show("CFG_RELOAD")
											end
										end,					
									},
									icon = {
										type = "group",
										order = 5,
										name = L["Castbar Icon"],
										desc = L[""],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.arena.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.arena.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											---------------------------
											--Option Type Seperators
											sep1 = {
												type = "description",
												order = 2,						
												name = " ",
											},
											sep2 = {
												type = "description",
												order = 3,						
												name = " ",
											},
											sep3 = {
												type = "description",
												order = 4,						
												name = " ",
											},
											sep4 = {
												type = "description",
												order = 5,						
												name = " ",
											},	
											---------------------------											
											size = {
												order = 4,
												name = L["Icon Size"],
												desc = L[""],
												type = "range",
												min = 8, max = 50, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
										},
									},
								},
							},
						},
					},
				},
			},					
			nRaidframes = {
				order = 11,
				type = "group",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid"],
				desc = L[""],
				get = function(info) return db.nRaidframes[ info[#info] ] end,
				set = function(info, value) db.nRaidframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {
					---------------------------
					--Option Type Seperators
					sep1 = {
						type = "description",
						order = 2,						
						name = " ",
					},
					sep2 = {
						type = "description",
						order = 3,						
						name = " ",
					},
					sep3 = {
						type = "description",
						order = 4,						
						name = " ",
					},
					sep4 = {
						type = "description",
						order = 5,						
						name = " ",
					},	
					---------------------------					
					enable = {
						order = 0,
						name = L["Enable oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid"],
						desc = L[""],
						type = "toggle",
					},
					font = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid Font"],
						desc = L[""],
						disabled = function() return not db.nRaidframes.enable end,
						get = function(info) return db.nRaidframes.font[ info[#info] ] end,
						set = function(info, value) db.nRaidframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							fontSmallSize = {
								order = 4,
								name = L["Font Small Size"],
								desc = L[""],
								type = "range",
								
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							fontBigSize = {
								order = 4,
								name = L["Font Big Size"],
								desc = L[""],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
						},
					},							
					raid = {
						type = "group",
						order = 5,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid"],
						desc = L[""],
						disabled = function() return not db.nRaidframes.enable end,
						get = function(info) return db.nRaidframes.units.raid[ info[#info] ] end,
						set = function(info, value) db.nRaidframes.units.raid[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							---------------------------
							--Option Type Seperators
							sep1 = {
								type = "description",
								order = 2,						
								name = " ",
							},
							sep2 = {
								type = "description",
								order = 3,						
								name = " ",
							},
							sep3 = {
								type = "description",
								order = 4,						
								name = " ",
							},
							sep4 = {
								type = "description",
								order = 5,						
								name = " ",
							},	
							---------------------------							
							showSolo = {
								order = 1,
								name = L["Show Solo"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showParty = {
								order = 1,
								name = L["Show in Party"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							nameLength= {
								order = 4,
								name = L["Name Length"],
								desc = L[""],
								type = "range",
								min = 2, max = 20, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							width= {
								order = 4,
								name = L["Width"],
								desc = L[""],
								type = "range",
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							height= {
								order = 4,
								name = L["Height"],
								desc = L[""],
								type = "range",
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							scale= {
								order = 4,
								name = L["Raid Frame Scale"],
								desc = L[""],
								type = "range",	
								min = 0.5, max = 2, step = 0.1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							layout = {
								type = "group",
								order = 5,
								name = L["Raid Frame Layout"],
								desc = L[""],	
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info) return db.nRaidframes.units.raid.layout[ info[#info] ] end,
								set = function(info, value) db.nRaidframes.units.raid.layout[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									frameSpacing = {
										order = 4,
										name = L["Frame Spacing"],
										desc = L[""],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nRaidframes.enable end,
									},
									numGroups = {
										order = 4,
										name = L["Number of Groups"],
										desc = L[""],
										type = "range",
										min = 0, max = 8, step = 1,
										disabled = function() return not db.nRaidframes.enable end,
									},
									initialAnchor = {
										order = 2,
										name = L["Initial Anchor"],
										desc = L[""],
										disabled = function() return not db.nRaidframes.enable end,
										type = "select",
										values = N.regions;
									},
									orientation = {
										order = 2,
										name = L["Orientation"],
										desc = L[""],
										disabled = function() return not db.nRaidframes.enable end,
										type = "select",
										values = N.orientation;
									},													
								},
							},									
							smoothUpdates = {
								order = 1,
								name = L["Smooth Updates"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showThreatText = {
								order = 1,
								name = L["Show Threat Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showRolePrefix = {
								order = 1,
								name = L["Show Role Prefix"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showNotHereTimer = {
								order = 1,
								name = L["Show Not Here Timer"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showMainTankIcon = {
								order = 1,
								name = L["Show Main Tank Icon"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showResurrectText = {
								order = 1,
								name = L["Show Resurrect Text"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showMouseoverHighlight = {
								order = 1,
								name = L["Show Mouseover Highlight"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showTargetBorder = {
								order = 1,
								name = L["Show Target Border"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							targetBorderColor = {
								order = 3,
								type = "color",
								name = L["Target Border Color"],
								desc = L[""],
								hasAlpha = false,
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info)
									local tbc = db.nRaidframes.units.raid[ info[#info] ]
									if tbc then
										return tbc.r, tbc.g, tbc.b
									end
								end,
								set = function(info, r, g, b)
									db.nRaidframes.units.raid[ info[#info] ] = {}
									local tbc = db.nRaidframes.units.raid[ info[#info] ]
									if tbc then
										tbc.r, tbc.g, tbc.b = r, g, b
										StaticPopup_Show("CFG_RELOAD")
									end
								end,					
							},
							iconSize = {
								order = 4,
								name = L["Debuff Icon Size"],
								desc = L[""],
								type = "range",
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							indicatorSize = {
								order = 4,
								name = L["Indicator Size"],
								desc = L[""],
								type = "range",	
								min = 0, max = 20, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							horizontalHealthBars = {
								order = 1,
								name = L["Horizontal Health Bars"],
								desc = L[""],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							deficitThreshold= {
								order = 4,
								name = L["Deficit Threshold"],
								desc = L[""],
								type = "range",
								min = 0.05, max = 1, step = 0.05,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							manabar = {
								type = "group",
								order = 5,
								name = L["Raid Manabar"],
								desc = L[""],	
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info) return db.nRaidframes.units.raid.manabar[ info[#info] ] end,
								set = function(info, value) db.nRaidframes.units.raid.manabar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									---------------------------
									--Option Type Seperators
									sep1 = {
										type = "description",
										order = 2,						
										name = " ",
									},
									sep2 = {
										type = "description",
										order = 3,						
										name = " ",
									},
									sep3 = {
										type = "description",
										order = 4,						
										name = " ",
									},
									sep4 = {
										type = "description",
										order = 5,						
										name = " ",
									},	
									---------------------------									
									show = {
										order = 1,
										name = L["Show"],
										desc = L[""],
										type = "toggle",
										
										disabled = function() return not db.nRaidframes.enable end,
									},
									horizontalOrientation = {
										order = 1,
										name = L["Horizontal Orientation"],
										desc = L[""],
										type = "toggle",
										disabled = function() return not db.nRaidframes.enable end,
									},
								},
							},
						},
					},
				},
			},		
		},
	}

end
