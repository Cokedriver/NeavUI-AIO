local NeavUIConfig = LibStub("AceAddon-3.0"):NewAddon("NeavUIConfig", "AceConsole-3.0", "AceEvent-3.0")
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
			general = DB["general"],
			buff = DB["buff"],
			chat = DB["chat"],				
			mainbar = DB["mainbar"],
			minimap = DB["minimap"],			
			plates = DB["plates"],
			power = DB["power"],			
			tooltip = DB["tooltip"],
			unitframes = DB["unitframes"],
			raidframes = DB["raidframes"],			
		},
		global = {
			BlackBook = {
				alts = {},
			},
		},		
	}
end	


function NeavUIConfig:OnInitialize()	
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
	
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NeavUIConfig", "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI");
	self.optionsFrame.default = function() self:SetDefaultOptions(); ReloadUI(); end;
	self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NeavUIProfiles", L["|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI Profiles"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI");	
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
		text = L["One or more of the changes you have made require a ReloadUI."],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function() ReloadUI() end,
		timeout = 0,
		whileDead = 1,
	}	
	NeavUIConfig.Options = {
		type = "group",
		name = "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI",
		childGroups = "tree",
		args = {
			intro = {
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
					text2 = {
						order = 3,
						type = "description",
						fontSize = "large",
						name = L["|cffCC3333Commands:|r"],				
					},					
					text3 = {
						order = 4,
						type = "description",
						fontSize = "medium",
						name = L["/neavrt to move the raid frames."],				
					},
					text4 = {
						order = 5,
						type = "description",
						fontSize = "medium",
						name = L["/wm, /worldmarkers, /rm or /raidmarkers to show world raid markers."],				
					},
					text5 = {
						order = 6,
						type = "description",
						fontSize = "medium",
						name = L["/rolecheck or /rcheck to do a role check."],				
					},
				},
			},				
			general = {
				order = 1,
				type = "group",
				name = L["|cffCC3333n|rCore"],
				--desc = L["General Modules for NeavUI."],
				get = function(info) return db.general[ info[#info] ] end,
				set = function(info, value) db.general[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333n|rCore."],
					},
					altbuy = {
						order = 2,
						name = L["Alt Buy"],
						--desc = L["Enables Holding Alt at a vendor to Buy a Full Stack"],
						type = "toggle",							
					},
					autogreed = {
						order = 3,
						name = L["Cooldown"],
						--desc = L["Enables Automatically rolling greed on green items when in a instance."],
						type = "toggle",						
					},
					bubbles = {
						order = 4,
						name = L["Bubbles"],
						--desc = L["Enables NeavUi Borde for Chat Bubbles"],
						type = "toggle",						
					},
					coords = {
						order = 5,
						name = L["Coords"],
						--desc = L["Enables Coords on Main Map"],
						type = "toggle",
					},
					durability = {
						order = 5,
						name = L["Durability"],
						--desc = L["Enables Durability on Charactor Frame."],
						type = "toggle",
					},	
					mail = {
						order = 5,
						name = L["Mail"],
						--desc = L["Enables Open All Mail."],
						type = "toggle",
					},	
					omnicc = {
						order = 5,
						name = L["OmniCC"],
						--desc = L["Enables OmniCC on Actionbars."],
						type = "toggle",
					},	
					quicky = {
						order = 5,
						name = L["Quicky"],
						--desc = L["Enables Quicky Helm & Cloak."],
						type = "toggle",
					},
					skins = {
						order = 5,
						name = L["Skins"],
						--desc = L["Enables the Skinning of other addons Recount, DMB, Omen, etc."],
						type = "toggle",
					},
					spellid = {
						order = 5,
						name = L["SpellID"],
						--desc = L["Enables SpellID in Tooltips."],
						type = "toggle",
					},
					warning = {
						order = 5,
						name = L["Warning"],
						--desc = L["Enables the removal of unwanted Error Messages."],
						type = "toggle",
					},
					watchframe = {
						order = 5,
						name = L["Watchframe"],
						--desc = L["Enables customized Watchframe."],
						type = "toggle",
					},					
				},
			},
			buff = {
				order = 2,
				type = "group",
				name = L["|cffCC3333n|rBuff"],
				--desc = L["Rescale the size of your buffs."],
				get = function(info) return db.buff[ info[#info] ] end,
				set = function(info, value) db.buff[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rBuff."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables |cffCC3333 n|rBuff"],
						type = "toggle",							
					},
					buffBorderColor = {
						order = 3,
						type = "color",
						name = L["Buff Border Color"],
						--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
						hasAlpha = false,
						disabled = function() return not db.buff.enable end,
						get = function(info)
							local hb = db.buff[ info[#info] ]
							return hb.r, hb.g, hb.b
						end,
						set = function(info, r, g, b)
							db.buff[ info[#info] ] = {}
							local hb = db.buff[ info[#info] ]
							hb.r, hb.g, hb.b = r, g, b
							StaticPopup_Show("CFG_RELOAD") 
						end,					
					},					
					buffSize = {
						order = 4,
						name = L["Buff Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					buffScale = {
						order = 5,
						name = L["Buff Scale"],
						--desc = L["Controls the scaling of the Buff Frames"],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.buff.enable end,
					},
					buffFontSize = {
						order = 6,
						name = L["Buff Font Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 8, max = 25, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					buffCountSize = {
						order = 7,
						name = L["Buff Count Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					debuffSize = {
						order = 8,
						name = L["DeBuff Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					debuffScale = {
						order = 9,
						name = L["DeBuff Scale"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.buff.enable end,
					},
					debuffFontSize = {
						order = 10,
						name = L["DeBuff Font Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 8, max = 25, step = 0.05,
						disabled = function() return not db.buff.enable end,
					},
					debuffCountSize = {
						order = 11,
						name = L["DeBuff Count Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					paddingX = {
						order = 12,
						name = L["Padding X"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.buff.enable end,
					},
					paddingY = {
						order = 13,
						name = L["Padding Y"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.buff.enable end,
					},						
					buffPerRow = {
						order = 14,
						name = L["Buffs Per Row"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.buff.enable end,
					},					
				},
			},			
			chat = {
				order = 3,
				type = "group",
				name = L["|cffCC3333n|rChat"],
				--desc = L["Modify the chat window and settings."],
				get = function(info) return db.chat[ info[#info] ] end,
				set = function(info, value) db.chat[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rChat."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables Chat Module."],
						type = "toggle",							
					},					
					disableFade = {
						order = 3,
						name = L["Disable Fade"],
						--desc = L["Disables Chat Fading."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},
					chatOutline = {
						order = 4,
						name = L["Chat Outline"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},
					chatBorder = {
						order = 4,
						name = L["Chat Border"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},
					chatBorderClassColor = {
						order = 4,
						name = L["Chat Border Class Color"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.chat.chatBorder or not db.chat.enable end,
					},
					enableBottomButton = {
						order = 5,
						name = L["Enable Bottom Button"],
						--desc = L["Enables the scroll down button in the lower right hand corner."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},
					enableHyperlinkTooltip = {
						order = 6,
						name = L["Enable Hyplerlink Tooltip"],
						--desc = L["Enables the mouseover items in chat tooltip."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},
					enableBorderColoring = {
						order = 7,
						name = L["Enable Editbox Channel Border Coloring"],
						--desc = L["Enables the coloring of the border to the edit box to match what channel you are typing in."],
						type = "toggle",
						disabled = function() return not db.chat.enable end,
					},					
					tab = {
						type = "group",
						order = 8,
						guiInline = true,
						name = L["Tab"],
						--desc = L["Tab Font Settings."],
						disabled = function() return not db.chat.enable end,
						get = function(info) return db.chat.tab[ info[#info] ] end,
						set = function(info, value) db.chat.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["Tab Font Settings."],
							},					
							fontOutline = {
								order = 2,
								name = L["Outline Tab Font"],
								--desc = L["Enables the outlineing of tab font."],
								type = "toggle",								
							},
							normalColor = {
								order = 3,
								type = "color",
								name = L["Tab Normal Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.chat.enable end,
								get = function(info)
									local hb = db.chat.tab[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.chat.tab[ info[#info] ] = {}
									local hb = db.chat.tab[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							specialColor = {
								order = 4,
								type = "color",
								name = L["Tab Special Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.chat.enable end,
								get = function(info)
									local hb = db.chat.tab[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.chat.tab[ info[#info] ] = {}
									local hb = db.chat.tab[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							selectedColor = {
								order = 5,
								type = "color",
								name = L["Tab Selected Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.chat.enable end,
								get = function(info)
									local hb = db.chat.tab[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.chat.tab[ info[#info] ] = {}
									local hb = db.chat.tab[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							fontSize = {
								type = "range",
								order = 6,
								name = L["Font Scale"],
								--desc = L["Controls the size of the tab font"],
								type = "range",
								min = 9, max = 20, step = 1,									
							},							
						},
					},
				},
			},
			mainbar = {
				order = 4,
				type = "group",
				name = L["|cffCC3333n|rMainbar"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.mainbar[ info[#info] ] end,
				set = function(info, value) db.mainbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rMainbar."],
					},			
					enable = {
						type = "toggle",
						order = 2,
						width = "full",
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					showPicomenu = {
						type = "toggle",
						order = 3,
						name = L["Pico Menu"],
						disabled = function() return not db.mainbar.enable end,
						--desc = L["Enable Nameplate Settings"],							
					},
					MainMenuBar = {
						type = "group",
						order = 4,
						name = L["MainMenuBar"],
						--desc = L["MainMenuBar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.MainMenuBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.MainMenuBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},
							hideGryphons = {
								order = 2,
								name = L["Hide Gryphons"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							shortBar = {
								order = 3,
								name = L["Shortbar"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							skinButton = {
								order = 4,
								name = L["Skin Buttons"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							moveableExtraBars = {
								order = 5,
								name = L["Moveable Extra Bars"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},					
					button = {
						type = "group",
						order = 5,
						name = L["Buttons"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.button[ info[#info] ] end,
						set = function(info, value) db.mainbar.button[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							showVehicleKeybinds = {
								order = 1,
								name = L["Vehicle Keybinds"],
								--desc = L["Enable HP Value on Nameplates."],
								width = "full",
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							showKeybinds = {
								order = 2,
								name = L["Keybinds"],
								--desc = L["Enable HP Value on Nameplates."],
								width = "full",
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},	
							showMacronames = {
								order = 3,
								name = L["Macronames"],
								--desc = L["Enable HP Value on Nameplates."],
								width = "full",
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},								
							countFontsize = {
								order = 4,
								name = L["Count Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.mainbar.enable end,
							},
							macronameFontsize = {
								order = 5,
								name = L["Macroname Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.mainbar.enable end,
							},
							hotkeyFontsize = {
								order = 6,
								name = L["Hot Key Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.mainbar.enable end,
							},
						},						
					},
					color = {
						type = "group",
						order = 6,
						name = L["Color"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.color[ info[#info] ] end,
						set = function(info, value) db.mainbar.color[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							Normal = {
								order = 1,
								type = "color",
								name = L["Normal"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							IsEquipped = {
								order = 2,
								type = "color",
								name = L["Is Equipped"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							OutOfRange = {
								order = 3,
								type = "color",
								name = L["Out of Range"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							OutOfMana = {
								order = 4,
								type = "color",
								name = L["Out of Mana"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							NotUsable = {
								order = 5,
								type = "color",
								name = L["Not Usable"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							HotKeyText = {
								order = 6,
								type = "color",
								name = L["Hot Key Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							MacroText = {
								order = 7,
								type = "color",
								name = L["Macro Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							CountText = {
								order = 8,
								type = "color",
								name = L["Count Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.mainbar.enable end,
								get = function(info)
									local hb = db.mainbar.color[ info[#info] ]
									return hb.r, hb.g, hb.b
								end,
								set = function(info, r, g, b)
									db.mainbar.color[ info[#info] ] = {}
									local hb = db.mainbar.color[ info[#info] ]
									hb.r, hb.g, hb.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
						},
					},
					expBar = {
						type = "group",
						order = 7,
						name = L["Experiance Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.expBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.expBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							fontsize = {
								order = 2,
								name = L["Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.mainbar.enable end,
							},	
						},						
					},
					repBar = {
						type = "group",
						order = 8,
						name = L["Reputation Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.repBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.repBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							fontsize = {
								order = 2,
								name = L["Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.mainbar.enable end,
							},	
						},						
					},
					vehicleBar = {
						type = "group",
						order = 9,
						name = L["Vehicle Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.vehicleBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.vehicleBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},	
						},						
					},
					petBar = {
						type = "group",
						order = 10,
						name = L["Pet Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.petBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.petBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							vertical = {
								order = 2,
								name = L["Vertical"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							scale = {
								order = 3,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					possessBar = {
						type = "group",
						order = 11,
						name = L["Possess Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.possessBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.possessBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {							
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},
							alpha = {
								order = 2,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					stanceBar = {
						type = "group",
						order = 12,
						name = L["Stance Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.stanceBar[ info[#info] ] end,
						set = function(info, value) db.mainbar.stanceBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							hide = {
								order = 2,
								name = L["Hide"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							scale = {
								order = 3,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					multiBarLeft = {
						type = "group",
						order = 13,
						name = L["MultiBarLeft"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.multiBarLeft[ info[#info] ] end,
						set = function(info, value) db.mainbar.multiBarLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							orderHorizontal = {
								order = 2,
								name = L["Order Horizontal"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					multiBarRight = {
						type = "group",
						order = 14,
						name = L["MultiBarRight"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.multiBarRight[ info[#info] ] end,
						set = function(info, value) db.mainbar.multiBarRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							orderHorizontal = {
								order = 2,
								name = L["Order Horizontal"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					multiBarBottomLeft = {
						type = "group",
						order = 15,
						name = L["MultibarBottomLeft"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.multiBarBottomLeft[ info[#info] ] end,
						set = function(info, value) db.mainbar.multiBarBottomLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							alpha = {
								order = 2,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},
					multiBarBottomRight = {
						type = "group",
						order = 16,
						name = L["Multibar Bottom Right"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.multiBarBottomRight[ info[#info] ] end,
						set = function(info, value) db.mainbar.multiBarBottomRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							orderVertical = {
								order = 2,
								name = L["Order Vertical"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},
							verticalPosition = {
								order = 4,
								name = L["Vertical Position"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.mainbar.enable end,
								type = "select",
								values = N.vPosition;
							},							
						},						
					},
					totemManager = {
						type = "group",
						order = 17,
						name = L["Totem Manager"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.mainbar.enable end,
						get = function(info) return db.mainbar.totemManager[ info[#info] ] end,
						set = function(info, value) db.mainbar.totemManager[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							hideRecallButton = {
								order = 1,
								name = L["Hide Recall Button"],
								--desc = L["Enable HP Value on Nameplates."],
								width = "full",
								type = "toggle",
								disabled = function() return not db.mainbar.enable end,
							},
							scale = {
								order = 2,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.mainbar.enable end,
							},								
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.mainbar.enable end,
							},							
						},						
					},					
				},
			},
			minimap = {
				order = 5,
				type = "group",
				name = L["|cffCC3333n|rMinimap"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.minimap[ info[#info] ] end,
				set = function(info, value) db.minimap[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rMinimap."],
					},			
					enable = {
						type = "toggle",
						order = 2,
						width = "full",
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					tab = {
						type = "group",
						order = 3,
						guiInline = true,
						name = L["Popup Tab"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.minimap.enable end,
						get = function(info) return db.minimap.tab[ info[#info] ] end,
						set = function(info, value) db.minimap.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							show = {
								type = "toggle",
								order = 1,
								name = L["Show"],
								--desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.minimap.enable end,
							},
							showAlways = {
								type = "toggle",
								order = 2,
								name = L["Show Always"],
								--desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.minimap.enable end,
							},
							showBelowMinimap = {
								type = "toggle",
								order = 3,
								name = L["Show Below Minimap"],
								--desc = L["Enable Nameplate Settings"],
								width = "full",
								disabled = function() return not db.minimap.enable end,
							},					
							alphaMouseover= {
								order = 4,
								name = L["Alpha Mouseover"],
								--desc = L["Controls the scale of the Nameplates Frame."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.minimap.enable end,
							},
							alphaNoMouseover= {
								order = 4,
								name = L["Alpha No Mouseover"],
								--desc = L["Controls the scale of the Nameplates Frame."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.minimap.enable end,
							},
						},
					},
					mouseover = {
						type = "group",
						order = 4,
						guiInline = true,
						name = L["Mouseover"],
						----desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.minimap.enable end,
						get = function(info) return db.minimap.mouseover[ info[#info] ] end,
						set = function(info, value) db.minimap.mouseover[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							zoneText = {
								type = "toggle",
								order = 1,
								name = L["Zone Text"],
								----desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.minimap.enable end,
							},
							instanceDifficulty = {
								type = "toggle",
								order = 2,
								name = L["Instance Difficulty"],
								----desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.minimap.enable end,
							},
						},
					},
				},
			},
				
			plates = {
				order = 6,
				type = "group",
				name = L["|cffCC3333n|rPlates"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.plates[ info[#info] ] end,
				set = function(info, value) db.plates[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rPlates"],
					},			
					enable = {
						type = "toggle",
						order = 2,
						width = "full",
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					enableTankMode = {
						type = "toggle",
						order = 3,
						name = L["Enable Tank Mode"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},				
					colorNameWithThreat = {
						type = "toggle",
						order = 4,
						name = L["Color Name With Threat"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},
					showFullHP = {
						type = "toggle",
						order = 5,
						name = L["Show Full HP"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},	
					showLevel = {
						type = "toggle",
						order = 6,
						name = L["Show Level"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},	
					showTargetBorder = {
						type = "toggle",
						order = 7,
						name = L["Show Target Border"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},	
					showEliteBorder = {
						type = "toggle",
						order = 8,
						name = L["Show Elite Border"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},	
					showTotemIcon = {
						type = "toggle",
						order = 9,
						name = L["Show Totem Icon"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},
					abbrevLongNames = {
						type = "toggle",
						order = 9,
						name = L["Abbrev Long Names"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.plates.enable end,
					},						
				},
			},
			power = {
				order = 7,
				type = "group",
				name = L["|cffCC3333n|rPower"],
				--desc = L["Powerbar for all classes with ComboPoints, Runes, Shards, and HolyPower."],
				get = function(info) return db.power[ info[#info] ] end,
				set = function(info, value) db.power[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rPower."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						width = "full",
						--desc = L["Enables Powerbar Module"],
						type = "toggle",							
					},					
					showCombatRegen = {
						order = 3,
						name = L["Show Combat Regen"],
						--desc = L["Shows a players Regen while in combat."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},				
					showSoulshards = {
						order = 4,
						name = L["Show Soulshards"],
						--desc = L["Shows Shards as a number value."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					showHolypower = {
						order = 5,
						name = L["Show Holypower"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					showMana = {
						order = 6,
						name = L["Show Mana"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					showFocus = {
						order = 7,
						name = L["Show Focus"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					showRage = {
						order = 8,
						name = L["Show Rage"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					valueAbbrev = {
						order = 9,
						name = L["Value Abbrev"],
						--desc = L["Shows Runes cooldowns as numbers."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					valueFontOutline = {
						order = 10,
						name = L["Value Font Outline"],
						--desc = L["Shows Focus power."],
						type = "toggle",
						disabled = function() return not db.power.enable end,
					},
					sizeWidth= {
						order = 11,
						name = L["Size Width"],
						--desc = L["Controls the width of power."],
						type = "range",
						min = 50, max = 350, step = 25,
						disabled = function() return not db.power.enable end,
					},					
					activeAlpha = {
						order = 12,
						name = L["Active Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.power.enable end,
					},
					inactiveAlpha = {
						order = 13,
						name = L["In Active Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.power.enable end,
					},
					emptyAlpha = {
						order = 14,
						name = L["Empty Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.power.enable end,
					},										
					valueFontSize = {
						order = 15,
						name = L["Value Font Size"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.power.enable end,
					},	
					valueFontAdjustmentX = {
						order = 16,
						name = L["Value Font Adjustment X"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not db.power.enable end,
					},
					position = {
						type = "group",
						order = 17,
						guiInline = true,
						name = L["|cffCC3333n|rPower Position"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.power.enable end,
						get = function(info) return db.power.position[ info[#info] ] end,
						set = function(info, value) db.power.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.power.enable end,
								type = "select",
								width = "full",
								values = N.regions;
							},
							offSetX= {
								order = 3,
								name = L["Off Set X"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.power.enable end,
							},
							offSetY= {
								order = 4,
								name = L["Off Set Y"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.power.enable end,
							},
						},
					},					
					energy = {
						type = "group",
						order = 18,
						guiInline = true,
						name = L["Energy"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.power.enable end,
						get = function(info) return db.power.energy[ info[#info] ] end,
						set = function(info, value) db.power.energy[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["Options for Rogue Energy / Combo Points"],
							},
							show = {
								order = 2,
								name = L["Show"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},
							showComboPoints = {
								order = 2,
								name = L["Show Combo Points"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},
							comboPointsBelow = {
								order = 2,
								name = L["Combo Points Below"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},							
							comboFontOutline = {
								order = 2,
								name = L["Combo Font Outline"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},
							comboFontSize = {
								order = 3,
								name = L["Combo Font Size"],
								--desc = L["Controls the ComboPoints font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.power.enable end,
							},
						},
					},
					rune = {
						type = "group",
						order = 19,
						guiInline = true,
						name = L["Rune"],
						--desc = L["Options for Rune Text."],	
						disabled = function() return not db.power.enable end,
						get = function(info) return db.power.rune[ info[#info] ] end,
						set = function(info, value) db.power.rune[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["Options Deathknight Runes."],
							},
							show = {
								order = 2,
								name = L["Show"],
								--desc = L["Adds a font outline to Runes."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},
							showRuneCooldown = {
								order = 3,
								name = L["Show Rune Cooldown"],
								--desc = L["Adds a font outline to Runes."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},							
							runeFontOutline = {
								order = 4,
								name = L["Rune Font Outline"],
								--desc = L["Adds a font outline to Runes."],
								type = "toggle",
								disabled = function() return not db.power.enable end,
							},
							runeFontSize= {
								order = 5,
								name = L["Rune Font Size"],
								--desc = L["Controls the Runes font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.power.enable end,
							},						
						},
					},					
				},
			},			
			tooltip = {
				order = 8,
				type = "group",
				name = L["|cffCC3333n|rTooltip"],
				--desc = L["Options for custom tooltip."],
				get = function(info) return db.tooltip[ info[#info] ] end,
				set = function(info, value) db.tooltip[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rTooltip."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables Tooltip Module"],
						type = "toggle",							
					},
					fontOutline = {
						order = 3,
						name = L["Font Outline"],
						--desc = L["Disables Tooltip Fade."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},					
					fontSize= {
						order = 4,
						name = L["Font Size"],
						--desc = L["Controls the width of power."],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.tooltip.enable end,
					},
					position = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Position"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.tooltip.enable end,
						get = function(info) return db.tooltip.position[ info[#info] ] end,
						set = function(info, value) db.tooltip.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.tooltip.enable end,
								type = "select",
								values = N.regions;
							},
							relAnchor = {
								order = 3,
								name = L["Rel Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.tooltip.enable end,
								type = "select",
								values = N.regions;
							},							
							offSetX= {
								order = 4,
								name = L["Off Set X"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
							offSetY= {
								order = 5,
								name = L["Off Set Y"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
						},
					},					
					disableFade = {
						order = 6,
						name = L["Disable Fade"],
						--desc = L["Disables Tooltip Fade."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					showOnMouseover = {
						order = 7,
						name = L["Show On Mouseover"],
						--desc = L["Disables Tooltip Fade."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					reactionBorderColor = {
						order = 8,
						name = L["Reaction Border Color"],
						--desc = L["Colors the borders match targets classcolors."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					itemqualityBorderColor = {
						order = 9,
						name = L["Item Quality Border Color"],
						--desc = L["Colors the border of the tooltip to match the items quality."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					abbrevRealmNames = {
						order = 10,
						name = L["Abbrev Realm Names"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					showPlayerTitles = {
						order = 11,
						name = L["Show Player Titles"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					showUnitRole = {
						order = 12,
						name = L["Show Unit Role"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},					
					showPVPIcons = {
						order = 13,
						name = L["Show PVP Icons"],
						--desc = L["Shows PvP Icons in tooltip."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					showMouseoverTarget = {
						order = 14,
						name = L["Mouseover Target"],
						--desc = L["Shows mouseover target."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					showItemLevel = {
						order = 15,
						name = L["Item Level"],
						--desc = L["Shows targets average item level."],
						type = "toggle",
						disabled = function() return not db.tooltip.enable end,
					},
					healthbar = {
						type = "group",
						order = 16,
						guiInline = true,
						name = L["Healthbar"],
						--desc = L["Players Healthbar Options."],
						disabled = function() return not db.tooltip.enable end,
						get = function(info) return db.tooltip.healthbar[ info[#info] ] end,
						set = function(info, value) db.tooltip.healthbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							showOutline = {
								order = 2,
								name = L["Font Outline"],
								--desc = L["Adds a font outline to health value."],
								type = "toggle",
								disabled = function() return not db.tooltip.enable end,
							},
							reactionColoring = {
								order = 3,
								name = L["Reaction Coloring"],
								--desc = L["Change healthbar color to targets classcolor. (Overides Custom Color)"],
								type = "toggle",
								disabled = function() return not db.tooltip.enable end,
							},							
							showHealthValue = {
								order = 4,
								name = L["Health Value"],
								--desc = L["Shows health value over healthbar."],
								type = "toggle",
								width = "full",
								disabled = function() return not db.tooltip.enable end,
							},
							healthFormat = {
								order = 5,
								name = L["Health Format 1"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.tooltip.enable end,
								type = "select",
								values = N.healthFormat;
							},
							healthFullFormat = {
								order = 7,
								name = L["Health Full Format"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.tooltip.enable end,
								type = "select",
								values = N.healthTag;
							},
							textPos = {
								order = 8,
								name = L["Text Position"],
								--desc = L["Health Value Position."],
								disabled = function() return not db.tooltip.enable end,
								type = "select",
								values = N.regions;
							},													
							fontSize= {
								order = 9,
								name = L["Font Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								width = "full",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},							
							customColor = {
								type = "group",
								order = 10,
								guiInline = true,
								name = L["Healthbar Custom Color"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.tooltip.enable end,
								get = function(info) return db.tooltip.healthbar.customColor[ info[#info] ] end,
								set = function(info, value) db.tooltip.healthbar.customColor[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {							
									apply = {
										order = 1,
										name = L["Apply Custom Color"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.tooltip.enable end,
									},
									color = {
										order = 2,
										type = "color",
										name = L["Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.tooltip.healthbar.customColor.apply or not db.tooltip.enable end,
										get = function(info)
											local hb = db.tooltip.healthbar.customColor[ info[#info] ]
											return hb.r, hb.g, hb.b
										end,
										set = function(info, r, g, b)
											db.tooltip.healthbar.customColor[ info[#info] ] = {}
											local hb = db.tooltip.healthbar.customColor[ info[#info] ]
											hb.r, hb.g, hb.b = r, g, b
										end,					
									},
								},
							},							
						},
					},					
				},
			},
			unitframes = {
				order = 9,
				type = "group",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r"],
				--desc = L["Options for custom tooltip."],
				get = function(info) return db.unitframes[ info[#info] ] end,
				set = function(info, value) db.unitframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables Tooltip Module"],
						type = "toggle",							
					},
					show = {
						type = "group",
						order = 3,
						guiInline = true,
						name = L["Show"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes.show[ info[#info] ] end,
						set = function(info, value) db.unitframes.show[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {							
							castbars = {
								order = 1,
								name = L["Castbars"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
							pvpicons = {
								order = 2,
								name = L["PvP Icons"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
							classPortraits = {
								order = 3,
								name = L["Class Portraits"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
							threeDPortraits = {
								order = 4,
								name = L["3D Portraits"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
							disableCooldown = {
								order = 5,
								name = L["Disable Cooldown"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
							portraitTimer = {
								order = 6,
								name = L["Portrait Timer"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.unitframes.enable end,
							},
						},
					},
					font = {
						type = "group",
						order = 4,
						guiInline = true,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Font"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes.font[ info[#info] ] end,
						set = function(info, value) db.unitframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							normalSize= {
								order = 1,
								name = L["Normal Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								width = "full",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
							normalBigSize= {
								order = 2,
								name = L["Normal Big Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								width = "full",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
						},
					},
					units = {
						type = "group",
						order = 5,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Unit Frames"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.unitframes.enable end,
						get = function(info) return db.unitframes.units[ info[#info] ] end,
						set = function(info, value) db.unitframes.units[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Unit Frames."],
							},
							text = {
								order = 1,
								type = "description",
								name = L["To the left you can choose one of the oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Unit Frames to customize to your likings."],
							},							
							player = {
								type = "group",
								order = 1,
								name = L["Player"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.player[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.player[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 1,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Player Frame."],
									},								
									scale= {
										order = 2,
										name = L["Player Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.500, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									style = {
										order = 3,
										name = L["Player Frame Style"],
										--desc = L["Health Value Position."],
										disabled = function() return not db.unitframes.enable end,
										type = "select",
										style = "radio",
										values = N.style;
									},
									mouseoverText = {
										order = 4,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showVengeance = {
										order = 5,
										name = L["Show Vengeance"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showSwingTimer = {
										order = 6,
										name = L["Show Swing Timer"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showStatusFlash = {
										order = 7,
										name = L["Show Status Flash"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showCombatFeedback = {
										order = 8,
										name = L["Show Combat Feedback"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									position = {
										type = "group",
										order = 9,
										name = L["Player Frame Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.player.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.player.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 2,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},							
											offSetX = {
												order = 3,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
										},
									},
									castbar = {
										type = "group",
										order = 10,
										name = L["Player Castbar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.player.castbar[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.player.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											show = {
												order = 1,
												name = L["Show"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												width = "full",
												disabled = function() return not db.unitframes.enable end,
											},
											width= {
												order = 2,
												name = L["Width"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 250, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											height= {
												order = 3,
												name = L["Height"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 50, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											scale= {
												order = 4,
												name = L["Scale"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 2, step = 0.001,
												disabled = function() return not db.unitframes.enable end,
											},
											showLatency = {
												order = 5,
												name = L["Show Latency"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.unitframes.enable end,
											},
											showSafezone = {
												order = 6,
												name = L["Show Safe Zone"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.unitframes.enable end,
											},
											safezoneColor = {
												order = 7,
												type = "color",
												name = L["Safe Zone Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.player.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.player.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.player.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.player.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},											
											classcolor = {
												order = 8,
												name = L["Class Color"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.unitframes.enable end,
											},
											color = {
												order = 9,
												type = "color",
												name = L["Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.player.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.player.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.player.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.player.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											icon = {
												type = "group",
												order = 10,
												name = L["Castbar Icon"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.player.castbar.icon[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.player.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {											
													show = {
														order = 1,
														name = L["Show"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													positionOutside = {
														order = 2,
														name = L["Position Outside"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													position = {
														order = 2,
														name = L["Icon Position"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.LorR;
													},
												},
											},
											position = {
												type = "group",
												order = 11,
												name = L["Player Castbar Position"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.player.castbar.position[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.player.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {
													selfAnchor = {
														order = 2,
														name = L["Self Anchor"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.regions;
													},
													relAnchor = {
														order = 3,
														name = L["Rel Anchor"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.regions;
													},							
													offSetX = {
														order = 4,
														name = L["Off Set X"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = -100, max = 100, step = 1,
														disabled = function() return not db.unitframes.enable end,
													},
													offSetY = {
														order = 5,
														name = L["Off Set Y"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = -100, max = 100, step = 1,
														disabled = function() return not db.unitframes.enable end,
													},
												},
											},
										},
									},
								},
							},
							pet = {
								type = "group",
								order = 2,
								name = L["Pet"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.pet[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.pet[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Pet Frame."],
									},									
									scale= {
										order = 1,
										name = L["Pet Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.500, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									auraSize= {
										order = 2,
										name = L["Aura Size"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 10, max = 40, step = 1,
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 4,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showPowerPercent = {
										order = 5,
										name = L["Show Power Percent"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									position = {
										type = "group",
										order = 6,
										name = L["Pet Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.pet.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.pet.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {							
											offSetX = {
												order = 1,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											offSetY = {
												order = 2,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
										},
									},
									castbar = {
										type = "group",
										order = 7,
										name = L["Pet Castbar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.pet.castbar[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.pet.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											show = {
												order = 1,
												name = L["Show"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												width = "full",
												disabled = function() return not db.unitframes.enable end,
											},
											width= {
												order = 2,
												name = L["Width"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 250, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											height= {
												order = 3,
												name = L["Height"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 50, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											scale= {
												order = 4,
												name = L["Scale"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 2, step = 0.001,
												disabled = function() return not db.unitframes.enable end,
											},
											color = {
												order = 5,
												type = "color",
												name = L["Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.pet.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.pet.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.pet.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.pet.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											icon = {
												type = "group",
												order = 6,
												name = L["Castbar Icon"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.pet.castbar.icon[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.pet.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {											
													show = {
														order = 1,
														name = L["Show"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													positionOutside = {
														order = 2,
														name = L["Position Outside"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													position = {
														order = 3,
														name = L["Icon Position"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.LorR;
													},
												},
											},
											position = {
												type = "group",
												order = 7,
												name = L["Pet Castbar Position"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.pet.castbar.position[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.pet.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {
													selfAnchor = {
														order = 1,
														name = L["Self Anchor"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.regions;
													},
													relAnchor = {
														order = 2,
														name = L["Rel Anchor"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
														type = "select",
														values = N.regions;
													},							
													offSetX = {
														order = 3,
														name = L["Off Set X"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = -100, max = 100, step = 1,
														disabled = function() return not db.unitframes.enable end,
													},
													offSetY = {
														order = 4,
														name = L["Off Set Y"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = -100, max = 100, step = 1,
														disabled = function() return not db.unitframes.enable end,
													},
												},
											},
										},
									},
									ignoreSpells = {
										order = 8,
										name = L["Ignore Spells"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
								},
							},
							target = {
								type = "group",
								order = 3,
								name = L["Target"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.target[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.target[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Target Frame."],
									},									
									scale= {
										order = 1,
										name = L["Target Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.500, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									numBuffs= {
										order = 2,
										name = L["Number of Buffs"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										min = 0, max = 8, step = 1,
										disabled = function() return not db.unitframes.enable end,
									},
									numDebuffs= {
										order = 3,
										name = L["Number of Debuffs"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										min = 0, max = 8, step = 1,
										disabled = function() return not db.unitframes.enable end,
									},
									colorPlayerDebuffsOnly = {
										order = 4,
										name = L["Color Player Debuffs Only"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showAllTimers = {
										order = 5,
										name = L["Show All Timers"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									disableAura = {
										order = 6,
										name = L["Disable Aura"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showComboPoints = {
										order = 7,
										name = L["Show Combo Points"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showComboPointsAsNumber = {
										order = 8,
										name = L["Show Combo Points As Number"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									numComboPointsColor = {
										order = 9,
										type = "color",
										name = L["Number Combo Points Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.unitframes.enable end,
										get = function(info)
											local hb = db.unitframes.units.target[ info[#info] ]
											return hb.r, hb.g, hb.b
										end,
										set = function(info, r, g, b)
											db.unitframes.units.target[ info[#info] ] = {}
											local hb = db.unitframes.units.target[ info[#info] ]
											hb.r, hb.g, hb.b = r, g, b
										end,					
									},
									mouseoverText = {
										order = 10,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showCombatFeedback = {
										order = 11,
										name = L["Show Combat Feedback"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									icon = {
										type = "group",
										order = 10,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.target.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.target.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											show = {
												order = 1,
												name = L["Show"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.unitframes.enable end,
											},
											positionOutside = {
												order = 2,
												name = L["Position Outside"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.unitframes.enable end,
											},
											position = {
												order = 2,
												name = L["Icon Position"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.unitframes.enable end,
												type = "select",
												values = N.LorR;
											},
										},
									},
									position = {
										type = "group",
										order = 11,
										name = L["Target Castbar Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.target.castbar.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.target.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 2,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.unitframes.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 3,
												name = L["Rel Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.unitframes.enable end,
												type = "select",
												values = N.regions;
											},							
											offSetX = {
												order = 4,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											offSetY = {
												order = 5,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
										},
									},
								},
							},
							targettarget = {
								type = "group",
								order = 4,
								name = L["Target of Target"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.targettarget[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.targettarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Target of Target Frame."],
									},									
									scale= {
										order = 1,
										name = L["Target of Target Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									disableAura = {
										order = 2,
										name = L["Disable Aura"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 3,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
								},
							},
							focus = {
								type = "group",
								order = 5,
								name = L["Focus"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.focus[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.focus[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Focus Frame."],
									},									
									scale= {
										order = 1,
										name = L["Focus Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									numDebuffs= {
										order = 2,
										name = L["Number of Debuffs"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0, max = 10, step = 1,
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 3,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showPowerPercent = {
										order = 4,
										name = L["Show Power Percent"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									showCombatFeedback = {
										order = 5,
										name = L["Show Combat Feedback"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									enableFocusToggleKeybind = {
										order = 6,
										name = L["Enable Focus Toggle Keybind"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									focusToggleKey = {
										order = 7,
										name = L["Focus Toggle Key"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.unitframes.enable end,
										type = "select",
										values = N.type;
									},
									castbar = {
										type = "group",
										order = 8,
										name = L["Focus Castbar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.focus.castbar[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.focus.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											show = {
												order = 1,
												name = L["Show"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												width = "full",
												disabled = function() return not db.unitframes.enable end,
											},
											width= {
												order = 2,
												name = L["Width"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 250, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											height= {
												order = 3,
												name = L["Height"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 50, step = 1,
												disabled = function() return not db.unitframes.enable end,
											},
											scale= {
												order = 4,
												name = L["Scale"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 2, step = 0.001,
												disabled = function() return not db.unitframes.enable end,
											},
											color = {
												order = 5,
												type = "color",
												name = L["Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.focus.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.focus.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.focus.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.focus.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											interruptColor = {
												order = 5,
												type = "color",
												name = L["Interrupt Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.focus.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.focus.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.focus.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.focus.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											icon = {
												type = "group",
												order = 6,
												name = L["Castbar Icon"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.focus.castbar.icon[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.focus.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {											
													show = {
														order = 1,
														name = L["Show"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													positionOutside = {
														order = 2,
														name = L["Position Outside"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													position = {
														order = 3,
														name = L["Icon Position"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
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
								order = 6,
								name = L["Focus Target"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.focustarget[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.focustarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Focus Target Frame."],
									},									
									scale= {
										order = 1,
										name = L["Focus Target Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 2,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
								},
							},
							party = {
								type = "group",
								order = 7,
								name = L["Party"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.party[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.party[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Party Frame."],
									},									
									scale= {
										order = 1,
										name = L["Party Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									show = {
										order = 2,
										name = L["Show"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 3,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									hideInRaid = {
										order = 4,
										name = L["Hide In Raid"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									position = {
										type = "group",
										order = 5,
										name = L["Party Frame Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.party.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.party.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 1,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},							
											offSetX = {
												order = 2,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											offSetY = {
												order = 3,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
										},
									},
								},
							},
							boss = {
								type = "group",
								order = 8,
								name = L["Boss"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.boss[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.boss[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Boss Frame."],
									},									
									scale= {
										order = 1,
										name = L["Boss Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 2,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									position = {
										type = "group",
										order = 3,
										name = L["Boss Frame Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.boss.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.boss.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 1,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 2,
												name = L["Rel Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},											
											offSetX = {
												order = 3,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
										},
									},
									castbar = {
										type = "group",
										order = 4,
										name = L["Boss Castbar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.boss.castbar[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.boss.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											color = {
												order = 1,
												type = "color",
												name = L["Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.boss.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.boss.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.boss.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.boss.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											icon = {
												type = "group",
												order = 2,
												name = L["Castbar Icon"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.boss.castbar.icon[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.boss.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {											
													show = {
														order = 1,
														name = L["Show Icon"],
														--desc = L["Use the Custom Color you have chosen."],
														type = "toggle",
														disabled = function() return not db.unitframes.enable end,
													},
													size = {
														order = 2,
														name = L["Icon Size"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = 8, max = 50, step = 1,
														disabled = function() return not db.tooltip.enable end,
													},
													position = {
														order = 3,
														name = L["Icon Position"],
														--desc = L["Style of Border for Sqaure Minimap."],
														disabled = function() return not db.unitframes.enable end,
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
								order = 9,
								name = L["Arena"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.unitframes.enable end,
								get = function(info) return db.unitframes.units.arena[ info[#info] ] end,
								set = function(info, value) db.unitframes.units.arena[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 0,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Arena Frame."],
									},
									show = {
										order = 1,
										name = L["Show"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},									
									scale= {
										order = 2,
										name = L["Arena Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.001,
										disabled = function() return not db.unitframes.enable end,
									},
									auraSize= {
										order = 3,
										name = L["Aura Size"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 5, max = 50, step = 1,
										disabled = function() return not db.unitframes.enable end,
									},
									mouseoverText = {
										order = 4,
										name = L["Mouseover Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.unitframes.enable end,
									},
									position = {
										type = "group",
										order = 5,
										name = L["Arena Frame Position"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.arena.position[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.arena.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 1,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 2,
												name = L["Rel Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.tooltip.enable end,
												type = "select",
												values = N.regions;
											},											
											offSetX = {
												order = 3,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
										},
									},
									castbar = {
										type = "group",
										order = 6,
										name = L["Arena Castbar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.unitframes.enable end,
										get = function(info) return db.unitframes.units.arena.castbar[ info[#info] ] end,
										set = function(info, value) db.unitframes.units.arena.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											color = {
												order = 1,
												type = "color",
												name = L["Color"],
												--desc = L["Picks a Custom Color for the tooltip border."],
												hasAlpha = false,
												disabled = function() return not db.unitframes.units.arena.castbar.show or not db.unitframes.enable end,
												get = function(info)
													local hb = db.unitframes.units.arena.castbar[ info[#info] ]
													return hb.r, hb.g, hb.b
												end,
												set = function(info, r, g, b)
													db.unitframes.units.arena.castbar[ info[#info] ] = {}
													local hb = db.unitframes.units.arena.castbar[ info[#info] ]
													hb.r, hb.g, hb.b = r, g, b
												end,					
											},
											icon = {
												type = "group",
												order = 2,
												name = L["Castbar Icon"],
												--desc = L["Combo Points Options"],	
												guiInline = true,
												disabled = function() return not db.unitframes.enable end,
												get = function(info) return db.unitframes.units.arena.castbar.icon[ info[#info] ] end,
												set = function(info, value) db.unitframes.units.arena.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
												args = {											
													size = {
														order = 1,
														name = L["Icon Size"],
														--desc = L["Controls the width of power."],
														type = "range",
														min = 8, max = 50, step = 1,
														disabled = function() return not db.tooltip.enable end,
													},
												},
											},
										},
									},
								},
							},
						},
					},					
				},
			},
			raidframes = {
				order = 9,
				type = "group",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid"],
				--desc = L["Options for custom tooltip."],
				get = function(info) return db.raidframes[ info[#info] ] end,
				set = function(info, value) db.raidframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables Tooltip Module"],
						type = "toggle",							
					},
					font = {
						type = "group",
						order = 3,
						guiInline = true,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid Font"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.raidframes.enable end,
						get = function(info) return db.raidframes.font[ info[#info] ] end,
						set = function(info, value) db.raidframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							fontSmallSize = {
								order = 1,
								name = L["Font Small Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								width = "full",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
							fontBigSize = {
								order = 2,
								name = L["Font Big Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								width = "full",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.tooltip.enable end,
							},
						},
					},
					units = {
						type = "group",
						order = 4,
						guiInline = true,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid Unit Frames"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.raidframes.enable end,
						get = function(info) return db.raidframes.units[ info[#info] ] end,
						set = function(info, value) db.raidframes.units[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							intro = {
								order = 0,
								type = "description",
								name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid Frames."],
							},							
							raid = {
								type = "group",
								order = 1,
								name = L["Raid"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.raidframes.enable end,
								get = function(info) return db.raidframes.units.raid[ info[#info] ] end,
								set = function(info, value) db.raidframes.units.raid[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									intro = {
										order = 1,
										type = "description",
										name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid Frame."],
									},
									showSolo = {
										order = 2,
										name = L["Show Solo"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showParty = {
										order = 3,
										name = L["Show in Party"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									nameLength= {
										order = 4,
										name = L["Name Length"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 2, max = 20, step = 1,
										disabled = function() return not db.raidframes.enable end,
									},
									width= {
										order = 5,
										name = L["Width"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 10, max = 50, step = 1,
										disabled = function() return not db.raidframes.enable end,
									},
									height= {
										order = 6,
										name = L["Height"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 10, max = 50, step = 1,
										disabled = function() return not db.raidframes.enable end,
									},									
									scale= {
										order = 7,
										name = L["Raid Frame Scale"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.5, max = 2, step = 0.1,
										disabled = function() return not db.raidframes.enable end,
									},
									layout = {
										type = "group",
										order = 8,
										name = L["Raid Frame Layout"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.raidframes.enable end,
										get = function(info) return db.raidframes.units.raid.layout[ info[#info] ] end,
										set = function(info, value) db.raidframes.units.raid.layout[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {						
											frameSpacing = {
												order = 1,
												name = L["Frame Spacing"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 50, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											numGroups = {
												order = 2,
												name = L["Number of Groups"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 0, max = 8, step = 1,
												disabled = function() return not db.tooltip.enable end,
											},
											initialAnchor = {
												order = 3,
												name = L["Initial Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.raidframes.enable end,
												type = "select",
												values = N.regions;
											},
											orientation = {
												order = 4,
												name = L["Orientation"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.raidframes.enable end,
												type = "select",
												values = N.orientation;
											},													
										},
									},									
									smoothUpdates = {
										order = 9,
										name = L["Smooth Updates"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showThreatText = {
										order = 10,
										name = L["Show Threat Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showRolePrefix = {
										order = 11,
										name = L["Show Role Prefix"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showNotHereTimer = {
										order = 12,
										name = L["Show Not Here Timer"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showMainTankIcon = {
										order = 13,
										name = L["Show Main Tank Icon"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showResurrectText = {
										order = 14,
										name = L["Show Resurrect Text"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showMouseoverHighlight = {
										order = 15,
										name = L["Show Mouseover Highlight"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									showTargetBorder = {
										order = 16,
										name = L["Show Target Border"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									targetBorderColor = {
										order = 17,
										type = "color",
										name = L["Target Border Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.raidframes.enable end,
										get = function(info)
											local hb = db.raidframes.units.raid[ info[#info] ]
											return hb.r, hb.g, hb.b
										end,
										set = function(info, r, g, b)
											db.raidframes.units.raid[ info[#info] ] = {}
											local hb = db.raidframes.units.raid[ info[#info] ]
											hb.r, hb.g, hb.b = r, g, b
										end,					
									},
									iconSize = {
										order = 18,
										name = L["Debuff Icon Size"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 10, max = 50, step = 1,
										disabled = function() return not db.raidframes.enable end,
									},
									indicatorSize = {
										order = 19,
										name = L["Indicator Size"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0, max = 20, step = 1,
										disabled = function() return not db.raidframes.enable end,
									},									
									horizontalHealthBars = {
										order = 20,
										name = L["Horizontal Health Bars"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.raidframes.enable end,
									},
									deficitThreshold= {
										order = 21,
										name = L["Deficit Threshold"],
										--desc = L["Controls the healthbar value font size."],
										type = "range",
										width = "full",
										min = 0.05, max = 1, step = 0.05,
										disabled = function() return not db.raidframes.enable end,
									},									
									manabar = {
										type = "group",
										order = 22,
										name = L["Raid Manabar"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.raidframes.enable end,
										get = function(info) return db.raidframes.units.raid.manabar[ info[#info] ] end,
										set = function(info, value) db.raidframes.units.raid.manabar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											show = {
												order = 1,
												name = L["Show"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												width = "full",
												disabled = function() return not db.raidframes.enable end,
											},
											horizontalOrientation = {
												order = 2,
												name = L["Horizontal Orientation"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.raidframes.enable end,
											},
										},
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

function NeavUIConfig:SetDefaultOptions()
	local N, _, _ = unpack(NeavUI)
	local addon = self.db.profile;
	addon.buff = {
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
	addon.chat = {
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
	addon.general = {
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
	addon.mainbar = {	
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
	addon.minimap = {
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
	addon.plates = {
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
	addon.power = {
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
	addon.tooltip = {											
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
	addon.unitframes = {
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
				healthTag = '$perc',
				healthTagFull = '',
		   },

			['focus'] = {
				scale = 1.193,

				numDebuffs = 6,
				
				mouseoverText = false,
				healthTag = '$cur/$max',
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
					icon = {
						size = 22,
					},

					color = { r = 1, g = 0, b = 0 },
				},
			},
		},
	}
	addon.raidframes = {
		enable = false,
		media = {
			statusbar = 'Interface\\AddOns\\NeavUI\\Media\\statusbarTexture',                 -- Health- and Powerbar texture
		},

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
	
end