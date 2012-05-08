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
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.NeavUIConfig)
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
	
	--[[self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NeavUIConfig", "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI");
	self.optionsFrame.default = function() self:SetDefaultOptions(); ReloadUI(); end;
	self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("NeavUIProfiles", L["|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI Profiles"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI");	
	self.SetupOptions = nil]]
	
		-- The ordering here matters, it determines the order in the Blizzard Interface Options
	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames = {}
	self.optionsFrames.NeavUIConfig = ACD3:AddToBlizOptions("NeavUIConfig", "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r|cffffd200UI|r", nil, "nGeneral")
	self.optionsFrames.nMedia = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Media|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nMedia")
	self.optionsFrames.nCore = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Core|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nCore")
	self.optionsFrames.nBuff = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Buff|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nBuff")
	self.optionsFrames.nChat = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Chat|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nChat")
	self.optionsFrames.nData = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Data|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nData")
	self.optionsFrames.nMainbar = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Mainbar|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nMainbar")
	self.optionsFrames.nMinimap = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Minimap|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nMinimap")
	self.optionsFrames.nPlates = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Plates|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nPlates")
	self.optionsFrames.nPower = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Power|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nPower")
	self.optionsFrames.nTooltip = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|r|cffffd200Tooltip|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nTooltip")
	self.optionsFrames.nUnitframes = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffffd200oUF|r_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nUnitframes")
	self.optionsFrames.nRaidframes = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffffd200oUF|r_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r|cffffd200Raid|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "nRaidframes")
	--self.optionsFrames.SpellFilter = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|rFilters"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "spellfilter")
	--self.optionsFrames.Others = ACD3:AddToBlizOptions("NeavUIConfig", L["|cffCC3333n|rMisc"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI", "others")
	self.optionsFrames.Profiles = ACD3:AddToBlizOptions("NeavUIProfiles", L["|cffCC3333n|r|cffffd200Profiles|r"], "|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rUI")
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
		childGroups = "tab",
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
				--desc = L["Media Module for |cff00B4FFBasic|rUI."],
				order = 0,				
				type = "group",
				get = function(info) return db.nMedia[ info[#info] ] end,
				set = function(info, value) db.nMedia[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					font = {						
						name = L["|cffCC3333n|rFont"],
						--desc = L["The font that the core of the UI will use"],
						order = 1,
						type = 'select',
						dialogControl = 'LSM30_Font', --Select your widget here						
						values = AceGUIWidgetLSMlists.font,	
					},
					fontSize = {						
						name = L["|cffCC3333n|rFont Size"],
						--desc = L["Controls the Size of the Game Font"],
						order = 2,
						type = "range",
						min = 0, max = 30, step = 1,
					},
					sep1 = {
						order = 3,
						type = "description",
						name = " ",						
					},					
					classcolor = {
						order = 3,
						type = "toggle",
						name = L["Class Color"],
						desc = L["Use your classcolor for border and some text color."],						
					},
					color = {
						name = L["UI Border Color"],
						desc = L["Picks the UI Border Color if Class Color is not used."],
						order = 4,
						disabled = function() return db.nMedia.classcolor end,
						type = "color",						
						get = function(info)
							local rc = db.nMedia[ info[#info] ]
							return rc.r, rc.g, rc.b
						end,
						set = function(info, r, g, b)
							db.nMedia[ info[#info] ] = {}
							local rc = db.nMedia[ info[#info] ]
							rc.r, rc.g, rc.b = r, g, b
							StaticPopup_Show("CFG_RELOAD")
						end,										
					},					
				},
			},			
			nCore = {
				order = 1,
				type = "group",
				name = L["|cffCC3333n|rCore"],
				--desc = L["nCore Modules for NeavUI."],
				get = function(info) return db.nCore[ info[#info] ] end,
				set = function(info, value) db.nCore[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
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
						order = 2,
						name = L["Cooldown"],
						--desc = L["Enables Automatically rolling greed on green items when in a instance."],
						type = "toggle",						
					},
					bubbles = {
						order = 2,
						name = L["Bubbles"],
						--desc = L["Enables NeavUi Borde for Chat Bubbles"],
						type = "toggle",						
					},
					coords = {
						order = 2,
						name = L["Coords"],
						--desc = L["Enables Coords on Main Map"],
						type = "toggle",
					},
					durability = {
						order = 2,
						name = L["Durability"],
						--desc = L["Enables Durability on Charactor Frame."],
						type = "toggle",
					},	
					mail = {
						order = 2,
						name = L["Mail"],
						--desc = L["Enables Open All Mail."],
						type = "toggle",
					},
					merchant = {
						order = 3,
						type = "group",
						name = L["|cffCC3333n|rMerchant"],
						--desc = L["Merchant Module for |cff00B4FFBasic|rUI."],
						guiInline = true,
						get = function(info) return db.nCore.merchant[ info[#info] ] end,
						set = function(info, value) db.nCore.merchant[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {			
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable |cffCC3333n|rMerchant"],
								desc = L["Enable Merchant Settings"],							
							},
							autoRepair = {
								type = "toggle",
								order = 2,
								name = L["Auto Repair"],
								desc = L["Automatically repair when visiting a vendor"],
								disabled = function() return not db.nCore.merchant.enable end,
							},
							autoSellGrey = {
								type = "toggle",
								order = 3,
								name = L["Sell Grays"],
								desc = L["Automatically sell gray items when visiting a vendor"],
								disabled = function() return not db.nCore.merchant.enable end,
							},					
							sellMisc = {
								type = "toggle",
								order = 4,
								name = L["Sell Misc Items"],
								desc = L["Automatically sell a user selected item."],
								disabled = function() return not db.nCore.merchant.enable end,
							},
						},
					},					
					omnicc = {
						order = 2,
						name = L["OmniCC"],
						--desc = L["Enables OmniCC on Actionbars."],
						type = "toggle",
					},
					quest = {
						order = 3,
						type = "group",
						name = L["|cffCC3333n|rQuest"],
						--desc = L["Quest Module for |cff00B4FFBasic|rUI."],
						guiInline = true,
						get = function(info) return db.nCore.quest[ info[#info] ] end,
						set = function(info, value) db.nCore.quest[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {			
							enable = {
								order = 1,
								name = L["Enable |cffCC3333n|rQuest"],
								desc = L["Enables Quest Module"],
								type = "toggle",							
							},					
							autocomplete = {
								order = 2,
								name = L["Autocomplete"],
								desc = L["Automatically complete your quest."],
								type = "toggle",
								disabled = function() return not db.nCore.quest.enable end,
							},
						},
					},					
					quicky = {
						order = 2,
						name = L["Quicky"],
						--desc = L["Enables Quicky Helm & Cloak."],
						type = "toggle",
					},
					selfbuffs = {
						order = 3,
						type = "group",
						name = L["|cffCC3333n|rSelfbuffs"],
						--desc = L["Selfbuff Module for |cff00B4FFBasic|rUI."],
						guiInline = true,
						get = function(info) return db.nCore.selfbuffs[ info[#info] ] end,
						set = function(info, value) db.nCore.selfbuffs[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {			
							enable = {
								order = 1,
								name = L["Enable |cffCC3333n|rSelfbuffs"],
								desc = L["Enables Selfbuff Module"],
								type = "toggle",							
							},					
							playsound = {
								order = 2,
								name = L["Play Sound"],
								desc = L["Play's a warning sound when a players class buff is not applied."],
								type = "toggle",
								disabled = function() return not db.nCore.selfbuffs.enable end,
							},
							sound = {
								order = 4,
								name = L["Warning Sound"],
								desc = L["Pick the MP3 you want for your Warning Sound."],
								disabled = function() return not db.nCore.selfbuffs.enable end,
								type = "select",
								dialogControl = 'LSM30_Sound', --Select your widget here
								values = AceGUIWidgetLSMlists.sound,
							},				
						},
					},					
					skins = {
						order = 2,
						name = L["Skins"],
						--desc = L["Enables the Skinning of other addons Recount, DMB, Omen, etc."],
						type = "toggle",
					},
					spellid = {
						order = 2,
						name = L["SpellID"],
						--desc = L["Enables SpellID in Tooltips."],
						type = "toggle",
					},
					warning = {
						order = 2,
						name = L["Warning"],
						--desc = L["Enables the removal of unwanted Error Messages."],
						type = "toggle",
					},
					watchframe = {
						order = 2,
						name = L["Watchframe"],
						--desc = L["Enables customized Watchframe."],
						type = "toggle",
					},					
				},
			},
			nBuff = {
				order = 2,
				type = "group",
				name = L["|cffCC3333n|rBuff"],
				--desc = L["Rescale the size of your buffs."],
				get = function(info) return db.nBuff[ info[#info] ] end,
				set = function(info, value) db.nBuff[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rBuff."],
					},			
					enable = {
						order = 2,
						name = L["Enable |cffCC3333 n|rBuff."],
						--desc = L["Enables |cffCC3333 n|rBuff"],
						type = "toggle",
						width = "full",
					},				
					buffSize = {
						order = 4,
						name = L["Buff Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					buffScale = {
						order = 5,
						name = L["Buff Scale"],
						--desc = L["Controls the scaling of the nBuff Frames"],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					buffFontSize = {
						order = 6,
						name = L["Buff Font Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 8, max = 25, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					buffCountSize = {
						order = 7,
						name = L["Buff Count Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffSize = {
						order = 8,
						name = L["DeBuff Size"],
						--desc = L["Controls the scaling of Blizzard's nBuff Frames"],
						type = "range",
						min = 1, max = 50, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffScale = {
						order = 9,
						name = L["DeBuff Scale"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 0.5, max = 5, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffFontSize = {
						order = 10,
						name = L["DeBuff Font Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 8, max = 25, step = 0.05,
						disabled = function() return not db.nBuff.enable end,
					},
					debuffCountSize = {
						order = 11,
						name = L["DeBuff Count Size"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 10, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					paddingX = {
						order = 12,
						name = L["Padding X"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},
					paddingY = {
						order = 13,
						name = L["Padding Y"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},						
					buffPerRow = {
						order = 14,
						name = L["Buffs Per Row"],
						--desc = L["Controls the scaling of Blizzard's Buff Frames"],
						type = "range",
						min = 1, max = 20, step = 1,
						disabled = function() return not db.nBuff.enable end,
					},					
				},
			},			
			nChat = {
				order = 3,
				type = "group",
				name = L["|cffCC3333n|rChat"],
				--desc = L["Modify the chat window and settings."],
				get = function(info) return db.nChat[ info[#info] ] end,
				set = function(info, value) db.nChat[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rChat."],
					},			
					enable = {
						order = 2,
						name = L["Enable |cffCC3333n|rChat"],
						--desc = L["Enables Chat Module."],
						type = "toggle",							
					},					
					disableFade = {
						order = 3,
						name = L["Disable Fade"],
						--desc = L["Disables Chat Fading."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					chatOutline = {
						order = 4,
						name = L["Chat Outline"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					chatBorder = {
						order = 5,
						name = L["Border"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					chatBorderClassColor = {
						order = 6,
						name = L["Class Color Border"],
						--desc = L["Outlines the chat Text."],
						type = "toggle",
						disabled = function() return not db.nChat.chatBorder or not db.nChat.enable end,
					},
					enableBottomButton = {
						order = 7,
						name = L["Bottom Button"],
						--desc = L["Enables the scroll down button in the lower right hand corner."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					enableHyperlinkTooltip = {
						order = 8,
						name = L["Hyplerlink Tooltip"],
						--desc = L["Enables the mouseover items in chat tooltip."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},
					enableBorderColoring = {
						order = 9,
						name = L["Channel Border Coloring"],
						--desc = L["Enables the coloring of the border to the edit box to match what channel you are typing in."],
						type = "toggle",
						disabled = function() return not db.nChat.enable end,
					},					
					tab = {
						type = "group",
						order = 10,
						guiInline = true,
						name = L["Tab"],
						--desc = L["Tab Font Settings."],
						disabled = function() return not db.nChat.enable end,
						get = function(info) return db.nChat.tab[ info[#info] ] end,
						set = function(info, value) db.nChat.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
						args = {
							intro = {
								order = 1,
								type = "description",
								name = L["Tab Font Settings."],
							},					
							fontOutline = {
								order = 2,
								name = L["Font Outline"],
								--desc = L["Enables the outlineing of tab font."],
								type = "toggle",								
							},
							fontSize = {
								type = "range",
								width = "double",
								order = 2,
								name = L["Font Scale"],
								--desc = L["Controls the size of the tab font"],
								type = "range",
								min = 9, max = 20, step = 1,									
							},							
							normalColor = {
								order = 3,
								type = "color",
								name = L["Tab Normal Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tnc = db.nChat.tab[ info[#info] ]
									return tnc.r, tnc.g, tnc.b
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tnc = db.nChat.tab[ info[#info] ]
									tnc.r, tnc.g, tnc.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							specialColor = {
								order = 3,
								type = "color",
								name = L["Tab Special Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tsc = db.nChat.tab[ info[#info] ]
									return tsc.r, tsc.g, tsc.b
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tsc = db.nChat.tab[ info[#info] ]
									tsc.r, tsc.g, tsc.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							selectedColor = {
								order = 3,
								type = "color",
								name = L["Tab Selected Color"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nChat.enable end,
								get = function(info)
									local tsc = db.nChat.tab[ info[#info] ]
									return tsc.r, tsc.g, tsc.b
								end,
								set = function(info, r, g, b)
									db.nChat.tab[ info[#info] ] = {}
									local tsc = db.nChat.tab[ info[#info] ]
									tsc.r, tsc.g, tsc.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
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
				--desc = L["nData Module for |cff00B4FFBasic|rUI."],
				childGroups = "tree",
				get = function(info) return db.nData[ info[#info] ] end,
				set = function(info, value) db.nData[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,				
				args = {
					enable = {
						order = 1,
						name = L["Enable |cffCC3333n|rData"],
						--desc = L["Enables nData Module."],
						type = "toggle",
						width ="full",
					},					
					time24 = {
						order = 4,
						type = "toggle",
						name = L["24-Hour Time"],
						desc = L["Display time nData on a 24 hour time scale"],
							disabled = function() return not db.nData.enable end,					
					},					
					bag = {
						order = 5,
						type = "toggle",
						name = L["Bag Open"],
						desc = L["Checked opens Backpack only, Unchecked opens all bags."],
						disabled = function() return not db.nData.enable end,						
					},				
					battleground = {
						order = 6,
						type = "toggle",
						name = L["Battleground Text"],
						desc = L["Display special nDatas when inside a battleground"],
						disabled = function() return not db.nData.enable end,						
					},					
					localtime = {
						order = 7,
						type = "toggle",
						name = L["Local Time"],
						desc = L["Display local time instead of server time"],
						disabled = function() return not db.nData.enable end,						
					},
					recountraiddps = {
						order = 8,
						type = "toggle",
						name = L["Recount Raid DPS"],
						desc = L["Display Recount's Raid DPS (RECOUNT MUST BE INSTALLED)"],
						disabled = function() return not db.nData.enable end,								
					},						
					threatbar = {
						order = 9,
						type = "toggle",
						name = L["Threatbar"],
						desc = L["Display Threat Text in center of panel."],
						disabled = function() return not db.nData.enable end,						
					},
					databorder = {
						order = 10,
						name = L["Datapanel Border Style"],
						--desc = L["Style of Border for Sqaure Minimap."],
						disabled = function() return not db.nData.enable end,
						type = "select",
						style = "radio",
						values = N.border;
					},									
					DataGroup = {
						order = 12,
						type = "group",
						guiInline = true,
						name = L["Text Options"],
						disabled = function() return not db.nData.enable end,						
						args = {
							fontsize = {
								order = 0,
								name = L["Text Scale"],
								--desc = L["Font size for nDatas"],
								type = "range",
								min = 9, max = 25, step = 1,
								disabled = function() return not db.nData.enable end,						
							},
							sep1 = {
								order = 1,
								type = "description",
								name = " ",						
							},							
							bags = {
								order = 1,
								type = "range",
								name = L["Bags"],
								desc = L["Display ammount of bag space"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							calltoarms = {
								order = 2,
								type = "range",
								name = L["Call to Arms"],
								desc = L["Display the active roles that will recieve a reward for completing a random dungeon"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,																
							},
							coords = {
								order = 3,
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
								order = 5,
								type = "range",
								name = L["Durability"],
								desc = L["Display your current durability"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,
							},
							friends = {
								order = 6,
								type = "range",
								name = L["Friends"],
								desc = L["Display current online friends"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							guild = {
								order = 7,
								type = "range",
								name = L["Guild"],
								desc = L["Display current online people in guild"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							hps_text = {
								order = 8,
								type = "range",
								name = L["HPS"],
								desc = L["Display ammount of HPS"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							pro = {
								order = 10,
								type = "range",
								name = L["Professions"],
								desc = L["Display Professions"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							recount = {
								order = 11,
								type = "range",
								name = L["Recount"],
								desc = L["Display Recount's DPS (RECOUNT MUST BE INSTALLED)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,								
							},							
							spec = {
								order = 12,
								type = "range",
								name = L["Talent Spec"],
								desc = L["Display current spec"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							stat1 = {
								order = 13,
								type = "range",
								name = L["Stat #1"],
								desc = L["Display stat based on your role (Avoidance-Tank, AP-Melee, SP/HP-Caster)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,			
							},							
							stat2 = {
								order = 14,
								type = "range",
								name = L["Stat #2"],
								desc = L["Display stat based on your role (Armor-Tank, Crit-Melee, Crit-Caster)"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,						
							},
							system = {
								order = 15,
								type = "range",
								name = L["System"],
								desc = L["Display FPS and Latency"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							wowtime = {
								order = 16,
								type = "range",
								name = L["Time"],
								desc = L["Display current time"]..L["\n\n0 - Disabled\n1 - POSITION #1\n2 - POSITION #2\n3 - POSITION #3\n4 - POSITION #4\n5 - POSITION #5\n6 - POSITION #6\n7 - POSITION #7\n8 - POSITION #8\n9 - POSITION #9"],
								min = 0, max = 9, step = 1,															
							},
							zone = {
								order = 17,
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
				order = 4,
				type = "group",
				name = L["|cffCC3333n|rMainbar"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.nMainbar[ info[#info] ] end,
				set = function(info, value) db.nMainbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rMainbar."],
					},			
					enable = {
						type = "toggle",
						order = 2,
						
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					showPicomenu = {
						type = "toggle",
						order = 3,
						name = L["Pico Menu"],
						disabled = function() return not db.nMainbar.enable end,
						--desc = L["Enable Nameplate Settings"],							
					},
					MainMenuBar = {
						type = "group",
						dropdownInline = true,
						order = 4,
						name = L["MainMenuBar"],
						--desc = L["MainMenuBar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.MainMenuBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.MainMenuBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								width = "double",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							hideGryphons = {
								order = 2,
								name = L["Hide Gryphons"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							shortBar = {
								order = 3,
								name = L["Shortbar"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							skinButton = {
								order = 4,
								name = L["Skin Buttons"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							moveableExtraBars = {
								order = 5,
								name = L["Moveable Extra Bars"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},					
					button = {
						type = "group",
						order = 5,
						name = L["Buttons"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.button[ info[#info] ] end,
						set = function(info, value) db.nMainbar.button[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							showVehicleKeybinds = {
								order = 1,
								name = L["Vehicle Keybinds"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							showKeybinds = {
								order = 2,
								name = L["Keybinds"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},	
							showMacronames = {
								order = 3,
								name = L["Macronames"],
								--desc = L["Enable HP Value on Nameplates."],
								
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},								
							countFontsize = {
								order = 4,
								name = L["Count Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
							macronameFontsize = {
								order = 5,
								name = L["Macroname Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
							hotkeyFontsize = {
								order = 6,
								name = L["Hot Key Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},
						},						
					},
					color = {
						type = "group",
						order = 6,
						name = L["Color"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.color[ info[#info] ] end,
						set = function(info, value) db.nMainbar.color[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							Normal = {
								order = 1,
								type = "color",
								name = L["Normal"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local bc = db.nMainbar.color[ info[#info] ]
									return bc.r, bc.g, bc.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local bc = db.nMainbar.color[ info[#info] ]
									bc.r, bc.g, bc.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							IsEquipped = {
								order = 2,
								type = "color",
								name = L["Is Equipped"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local ie = db.nMainbar.color[ info[#info] ]
									return ie.r, ie.g, ie.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local ie = db.nMainbar.color[ info[#info] ]
									ie.r, ie.g, ie.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							OutOfRange = {
								order = 3,
								type = "color",
								name = L["Out of Range"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local oor = db.nMainbar.color[ info[#info] ]
									return oor.r, oor.g, oor.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local oor = db.nMainbar.color[ info[#info] ]
									oor.r, oor.g, oor.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							OutOfMana = {
								order = 4,
								type = "color",
								name = L["Out of Mana"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local oom = db.nMainbar.color[ info[#info] ]
									return oom.r, oom.g, oom.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local oom = db.nMainbar.color[ info[#info] ]
									oom.r, oom.g, oom.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							NotUsable = {
								order = 5,
								type = "color",
								name = L["Not Usable"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local nu = db.nMainbar.color[ info[#info] ]
									return nu.r, nu.g, nu.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local nu = db.nMainbar.color[ info[#info] ]
									nu.r, nu.g, nu.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							HotKeyText = {
								order = 6,
								type = "color",
								name = L["Hot Key Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local hkt = db.nMainbar.color[ info[#info] ]
									return hkt.r, hkt.g, hkt.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local hkt = db.nMainbar.color[ info[#info] ]
									hkt.r, hkt.g, hkt.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							MacroText = {
								order = 7,
								type = "color",
								name = L["Macro Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local mt = db.nMainbar.color[ info[#info] ]
									return mt.r, mt.g, mt.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local mt = db.nMainbar.color[ info[#info] ]
									mt.r, mt.g, mt.b = r, g, b
									StaticPopup_Show("CFG_RELOAD") 
								end,					
							},
							CountText = {
								order = 8,
								type = "color",
								name = L["Count Text"],
								--desc = L["Picks the Shielded Color of the Nameplate Castbar."],
								hasAlpha = false,
								disabled = function() return not db.nMainbar.enable end,
								get = function(info)
									local ct = db.nMainbar.color[ info[#info] ]
									return ct.r, ct.g, ct.b
								end,
								set = function(info, r, g, b)
									db.nMainbar.color[ info[#info] ] = {}
									local ct = db.nMainbar.color[ info[#info] ]
									ct.r, ct.g, ct.b = r, g, b
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
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.expBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.expBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							fontsize = {
								order = 2,
								name = L["Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					repBar = {
						type = "group",
						order = 8,
						name = L["Reputation Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.repBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.repBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							fontsize = {
								order = 2,
								name = L["Font Size"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					vehicleBar = {
						type = "group",
						order = 9,
						name = L["Vehicle Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.vehicleBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.vehicleBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},	
						},						
					},
					petBar = {
						type = "group",
						order = 10,
						name = L["Pet Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.petBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.petBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							vertical = {
								order = 2,
								name = L["Vertical"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							scale = {
								order = 3,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					possessBar = {
						type = "group",
						order = 11,
						name = L["Possess Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.possessBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.possessBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {							
							scale = {
								order = 1,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 2,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					stanceBar = {
						type = "group",
						order = 12,
						name = L["Stance Bar"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.stanceBar[ info[#info] ] end,
						set = function(info, value) db.nMainbar.stanceBar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							hide = {
								order = 2,
								name = L["Hide"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							scale = {
								order = 3,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},
							alpha = {
								order = 4,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarLeft = {
						type = "group",
						order = 13,
						name = L["MultiBarLeft"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarLeft[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderHorizontal = {
								order = 2,
								name = L["Order Horizontal"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarRight = {
						type = "group",
						order = 14,
						name = L["MultiBarRight"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarRight[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderHorizontal = {
								order = 2,
								name = L["Order Horizontal"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarBottomLeft = {
						type = "group",
						order = 15,
						name = L["MultibarBottomLeft"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarBottomLeft[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarBottomLeft[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 2,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},
					multiBarBottomRight = {
						type = "group",
						order = 16,
						name = L["Multibar Bottom Right"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.multiBarBottomRight[ info[#info] ] end,
						set = function(info, value) db.nMainbar.multiBarBottomRight[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							mouseover = {
								order = 1,
								name = L["Mouseover"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							orderVertical = {
								order = 2,
								name = L["Order Vertical"],
								--desc = L["Enable HP Value on Nameplates."],
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},							
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},
							verticalPosition = {
								order = 4,
								name = L["Vertical Position"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nMainbar.enable end,
								type = "select",
								values = N.LorR;
							},							
						},						
					},
					totemManager = {
						type = "group",
						order = 17,
						name = L["Totem Manager"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMainbar.enable end,
						get = function(info) return db.nMainbar.totemManager[ info[#info] ] end,
						set = function(info, value) db.nMainbar.totemManager[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							hideRecallButton = {
								order = 1,
								name = L["Hide Recall Button"],
								--desc = L["Enable HP Value on Nameplates."],
								
								type = "toggle",
								disabled = function() return not db.nMainbar.enable end,
							},
							scale = {
								order = 2,
								name = L["Scale"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.5, max = 2, step = 0.5,
								disabled = function() return not db.nMainbar.enable end,
							},								
							alpha = {
								order = 3,
								name = L["Alpha"],
								--desc = L["Set the Scale of the Castbar."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMainbar.enable end,
							},							
						},						
					},					
				},
			},
			nMinimap = {
				order = 5,
				type = "group",
				name = L["|cffCC3333n|rMinimap"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.nMinimap[ info[#info] ] end,
				set = function(info, value) db.nMinimap[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rMinimap."],
					},			
					enable = {
						type = "toggle",
						order = 2,
						
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					tab = {
						type = "group",
						order = 3,
						guiInline = true,
						name = L["Popup Tab"],
						--desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMinimap.enable end,
						get = function(info) return db.nMinimap.tab[ info[#info] ] end,
						set = function(info, value) db.nMinimap.tab[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							show = {
								type = "toggle",
								order = 1,
								name = L["Show"],
								--desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.nMinimap.enable end,
							},
							showAlways = {
								type = "toggle",
								order = 2,
								name = L["Show Always"],
								--desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.nMinimap.enable end,
							},
							showBelowMinimap = {
								type = "toggle",
								order = 3,
								name = L["Show Below Minimap"],
								--desc = L["Enable Nameplate Settings"],
								
								disabled = function() return not db.nMinimap.enable end,
							},					
							alphaMouseover= {
								order = 4,
								name = L["Alpha Mouseover"],
								--desc = L["Controls the scale of the Nameplates Frame."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMinimap.enable end,
							},
							alphaNoMouseover= {
								order = 4,
								name = L["Alpha No Mouseover"],
								--desc = L["Controls the scale of the Nameplates Frame."],
								type = "range",
								min = 0.1, max = 1, step = 0.1,
								disabled = function() return not db.nMinimap.enable end,
							},
						},
					},
					mouseover = {
						type = "group",
						order = 4,
						guiInline = true,
						name = L["Mouseover"],
						----desc = L["Nameplate Castbar Options"],
						disabled = function() return not db.nMinimap.enable end,
						get = function(info) return db.nMinimap.mouseover[ info[#info] ] end,
						set = function(info, value) db.nMinimap.mouseover[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							zoneText = {
								type = "toggle",
								order = 1,
								name = L["Zone Text"],
								----desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.nMinimap.enable end,
							},
							instanceDifficulty = {
								type = "toggle",
								order = 2,
								name = L["Instance Difficulty"],
								----desc = L["Enable Nameplate Settings"],
								disabled = function() return not db.nMinimap.enable end,
							},
						},
					},
				},
			},
				
			nPlates = {
				order = 6,
				type = "group",
				name = L["|cffCC3333n|rPlates"],
				--desc = L["Options for Nameplates."],
				get = function(info) return db.nPlates[ info[#info] ] end,
				set = function(info, value) db.nPlates[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rPlates"],
					},			
					enable = {
						type = "toggle",
						order = 2,
						
						name = L["Enable"],
						--desc = L["Enable Nameplate Settings"],							
					},
					enableTankMode = {
						type = "toggle",
						order = 3,
						name = L["Enable Tank Mode"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},				
					colorNameWithThreat = {
						type = "toggle",
						order = 4,
						name = L["Color Name With Threat"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},
					showFullHP = {
						type = "toggle",
						order = 5,
						name = L["Show Full HP"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},	
					showLevel = {
						type = "toggle",
						order = 6,
						name = L["Show Level"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},	
					showTargetBorder = {
						type = "toggle",
						order = 7,
						name = L["Show Target Border"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},	
					showEliteBorder = {
						type = "toggle",
						order = 8,
						name = L["Show Elite Border"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},	
					showTotemIcon = {
						type = "toggle",
						order = 9,
						name = L["Show Totem Icon"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},
					abbrevLongNames = {
						type = "toggle",
						order = 9,
						name = L["Abbrev Long Names"],
						--desc = L["Enable Nameplate Settings"],
						disabled = function() return not db.nPlates.enable end,
					},						
				},
			},
			nPower = {
				order = 7,
				type = "group",
				name = L["|cffCC3333n|rPower"],
				--desc = L["Powerbar for all classes with ComboPoints, Runes, Shards, and HolyPower."],
				get = function(info) return db.nPower[ info[#info] ] end,
				set = function(info, value) db.nPower[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
				args = {
					intro = {
						order = 1,
						type = "description",
						name = L["Options for |cffCC3333 n|rPower."],
					},			
					enable = {
						order = 2,
						name = L["Enable"],
						
						--desc = L["Enables Powerbar Module"],
						type = "toggle",							
					},					
					showCombatRegen = {
						order = 3,
						name = L["Show Combat Regen"],
						--desc = L["Shows a players Regen while in combat."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},				
					showSoulshards = {
						order = 4,
						name = L["Show Soulshards"],
						--desc = L["Shows Shards as a number value."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showHolypower = {
						order = 5,
						name = L["Show Holypower"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showMana = {
						order = 6,
						name = L["Show Mana"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showFocus = {
						order = 7,
						name = L["Show Focus"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					showRage = {
						order = 8,
						name = L["Show Rage"],
						--desc = L["Shows Holypower as a number value."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					valueAbbrev = {
						order = 9,
						name = L["Value Abbrev"],
						--desc = L["Shows Runes cooldowns as numbers."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					valueFontOutline = {
						order = 10,
						name = L["Value Font Outline"],
						--desc = L["Shows Focus power."],
						type = "toggle",
						disabled = function() return not db.nPower.enable end,
					},
					sizeWidth= {
						order = 11,
						name = L["Size Width"],
						--desc = L["Controls the width of power."],
						type = "range",
						min = 50, max = 350, step = 25,
						disabled = function() return not db.nPower.enable end,
					},					
					activeAlpha = {
						order = 12,
						name = L["Active Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},
					inactiveAlpha = {
						order = 13,
						name = L["In Active Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},
					emptyAlpha = {
						order = 14,
						name = L["Empty Alpha"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 0, max = 1, step = 0.1,
						disabled = function() return not db.nPower.enable end,
					},										
					valueFontSize = {
						order = 15,
						name = L["Value Font Size"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.nPower.enable end,
					},	
					valueFontAdjustmentX = {
						order = 16,
						name = L["Value Font Adjustment X"],
						--desc = L["Shows ComboPoints as a number value."],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not db.nPower.enable end,
					},
					position = {
						type = "group",
						order = 17,
						guiInline = true,
						name = L["|cffCC3333n|rPower Position"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.position[ info[#info] ] end,
						set = function(info, value) db.nPower.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nPower.enable end,
								type = "select",
								values = N.regions;
							},
							offSetX= {
								order = 3,
								name = L["Off Set X"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
							offSetY= {
								order = 4,
								name = L["Off Set Y"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
						},
					},					
					energy = {
						type = "group",
						order = 18,
						guiInline = true,
						name = L["Energy"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.energy[ info[#info] ] end,
						set = function(info, value) db.nPower.energy[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								disabled = function() return not db.nPower.enable end,
							},
							showComboPoints = {
								order = 2,
								name = L["Show Combo Points"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							comboPointsBelow = {
								order = 2,
								name = L["Combo Points Below"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},							
							comboFontOutline = {
								order = 2,
								name = L["Combo Font Outline"],
								--desc = L["Adds a font outline to ComboPoints."],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							comboFontSize = {
								order = 3,
								name = L["Combo Font Size"],
								--desc = L["Controls the ComboPoints font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nPower.enable end,
							},
						},
					},
					rune = {
						type = "group",
						order = 19,
						guiInline = true,
						name = L["Rune"],
						--desc = L["Options for Rune Text."],	
						disabled = function() return not db.nPower.enable end,
						get = function(info) return db.nPower.rune[ info[#info] ] end,
						set = function(info, value) db.nPower.rune[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								disabled = function() return not db.nPower.enable end,
							},
							showRuneCooldown = {
								order = 3,
								name = L["Show Rune Cooldown"],
								--desc = L["Adds a font outline to Runes."],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},							
							runeFontOutline = {
								order = 4,
								name = L["Rune Font Outline"],
								--desc = L["Adds a font outline to Runes."],
								type = "toggle",
								disabled = function() return not db.nPower.enable end,
							},
							runeFontSize= {
								order = 5,
								name = L["Rune Font Size"],
								--desc = L["Controls the Runes font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nPower.enable end,
							},						
						},
					},					
				},
			},			
			nTooltip = {
				order = 8,
				type = "group",
				name = L["|cffCC3333n|rTooltip"],
				--desc = L["Options for custom tooltip."],
				get = function(info) return db.nTooltip[ info[#info] ] end,
				set = function(info, value) db.nTooltip[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,					
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
						disabled = function() return not db.nTooltip.enable end,
					},					
					fontSize= {
						order = 4,
						name = L["Font Size"],
						--desc = L["Controls the width of power."],
						type = "range",
						min = 8, max = 30, step = 1,
						disabled = function() return not db.nTooltip.enable end,
					},
					position = {
						type = "group",
						order = 5,
						guiInline = true,
						name = L["Position"],
						--desc = L["Combo Points Options"],	
						disabled = function() return not db.nTooltip.enable end,
						get = function(info) return db.nTooltip.position[ info[#info] ] end,
						set = function(info, value) db.nTooltip.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							selfAnchor = {
								order = 2,
								name = L["Self Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},
							relAnchor = {
								order = 3,
								name = L["Rel Anchor"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},							
							offSetX= {
								order = 4,
								name = L["Off Set X"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},
							offSetY= {
								order = 5,
								name = L["Off Set Y"],
								--desc = L["Controls the width of power."],
								type = "range",
								min = -100, max = 100, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},
						},
					},					
					disableFade = {
						order = 6,
						name = L["Disable Fade"],
						--desc = L["Disables Tooltip Fade."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showOnMouseover = {
						order = 7,
						name = L["Show On Mouseover"],
						--desc = L["Disables Tooltip Fade."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					reactionBorderColor = {
						order = 8,
						name = L["Reaction Border Color"],
						--desc = L["Colors the borders match targets classcolors."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					itemqualityBorderColor = {
						order = 9,
						name = L["Item Quality Border Color"],
						--desc = L["Colors the border of the tooltip to match the items quality."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					abbrevRealmNames = {
						order = 10,
						name = L["Abbrev Realm Names"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showPlayerTitles = {
						order = 11,
						name = L["Show Player Titles"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showUnitRole = {
						order = 12,
						name = L["Show Unit Role"],
						--desc = L["Shows players title in tooltip."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},					
					showPVPIcons = {
						order = 13,
						name = L["Show PVP Icons"],
						--desc = L["Shows PvP Icons in tooltip."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showMouseoverTarget = {
						order = 14,
						name = L["Mouseover Target"],
						--desc = L["Shows mouseover target."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					showItemLevel = {
						order = 15,
						name = L["Item Level"],
						--desc = L["Shows targets average item level."],
						type = "toggle",
						disabled = function() return not db.nTooltip.enable end,
					},
					healthbar = {
						type = "group",
						order = 16,
						guiInline = true,
						name = L["Healthbar"],
						--desc = L["Players Healthbar Options."],
						disabled = function() return not db.nTooltip.enable end,
						get = function(info) return db.nTooltip.healthbar[ info[#info] ] end,
						set = function(info, value) db.nTooltip.healthbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							showOutline = {
								order = 2,
								name = L["Font Outline"],
								--desc = L["Adds a font outline to health value."],
								type = "toggle",
								disabled = function() return not db.nTooltip.enable end,
							},
							reactionColoring = {
								order = 3,
								name = L["Reaction Coloring"],
								--desc = L["Change healthbar color to targets classcolor. (Overides Custom Color)"],
								type = "toggle",
								disabled = function() return not db.nTooltip.enable end,
							},							
							showHealthValue = {
								order = 4,
								name = L["Health Value"],
								--desc = L["Shows health value over healthbar."],
								type = "toggle",
								
								disabled = function() return not db.nTooltip.enable end,
							},
							healthFormat = {
								order = 5,
								name = L["Health Format 1"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.healthFormat;
							},
							healthFullFormat = {
								order = 7,
								name = L["Health Full Format"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.healthTag;
							},
							textPos = {
								order = 8,
								name = L["Text Position"],
								--desc = L["Health Value Position."],
								disabled = function() return not db.nTooltip.enable end,
								type = "select",
								values = N.regions;
							},													
							fontSize= {
								order = 9,
								name = L["Font Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nTooltip.enable end,
							},							
							customColor = {
								type = "group",
								order = 10,
								guiInline = true,
								name = L["Healthbar Custom Color"],
								--desc = L["Custom Coloring"],
								disabled = function() return not db.nTooltip.enable end,
								get = function(info) return db.nTooltip.healthbar.customColor[ info[#info] ] end,
								set = function(info, value) db.nTooltip.healthbar.customColor[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {							
									apply = {
										order = 1,
										name = L["Apply Custom Color"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nTooltip.enable end,
									},
									color = {
										order = 2,
										type = "color",
										name = L["Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nTooltip.healthbar.customColor.apply or not db.nTooltip.enable end,
										get = function(info)
											local hcc = db.nTooltip.healthbar.customColor[ info[#info] ]
											return hcc.r, hcc.g, hcc.b
										end,
										set = function(info, r, g, b)
											db.nTooltip.healthbar.customColor[ info[#info] ] = {}
											local hcc = db.nTooltip.healthbar.customColor[ info[#info] ]
											hcc.r, hcc.g, hcc.b = r, g, b
										end,					
									},
								},
							},							
						},
					},					
				},
			},
			nUnitframes = {
				order = 9,
				type = "group",
				childGroups = "select",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r (Please select which Unitframe you wish to change)."],
				--desc = L["Options for custom tooltip."],
				get = function(info) return db.nUnitframes[ info[#info] ] end,
				set = function(info, value) db.nUnitframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,	
				args = {		
					enable = {
						order = 2,
						name = L["Enable"],
						--desc = L["Enables Tooltip Module"],
						type = "toggle",							
					},
					show = {
						type = "group",
						guiInline = true,
						order = 3,
						name = L["Show"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.show[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.show[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {							
							castbars = {
								order = 1,
								name = L["Castbars"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							pvpicons = {
								order = 2,
								name = L["PvP Icons"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							classPortraits = {
								order = 3,
								name = L["Class Portraits"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							threeDPortraits = {
								order = 4,
								name = L["3D Portraits"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableCooldown = {
								order = 5,
								name = L["Disable Cooldown"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							portraitTimer = {
								order = 6,
								name = L["Portrait Timer"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					font = {
						type = "group",
						guiInline = true,
						order = 4,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Font"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.font[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							normalSize= {
								order = 1,
								name = L["Normal Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							normalBigSize= {
								order = 2,
								name = L["Normal Big Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},							
					player = {
						type = "group",
						order = 1,
						name = L["Player"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.player[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.player[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {								
							scale= {
								order = 2,
								name = L["Player Frame Scale"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							style = {
								order = 3,
								name = L["Player Frame Style"],
								--desc = L["Health Value Position."],
								disabled = function() return not db.nUnitframes.enable end,
								type = "select",
								style = "radio",
								values = N.style;
							},
							mouseoverText = {
								order = 4,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showVengeance = {
								order = 5,
								name = L["Show Vengeance"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showSwingTimer = {
								order = 6,
								name = L["Show Swing Timer"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showStatusFlash = {
								order = 7,
								name = L["Show Status Flash"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 8,
								name = L["Show Combat Feedback"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 9,
								name = L["Player Frame Position"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.player.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.player.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									selfAnchor = {
										order = 1,
										name = L["Self Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									sep1 = {
										order = 2,
										type = "description",
										name = " ",						
									},									
									offSetX = {
										order = 3,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 10,
								name = L["Player Castbar"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.player.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.player.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 1,
										name = L["Show Player Castbar"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										
										disabled = function() return not db.nUnitframes.enable end,
									},
									showLatency = {
										order = 2,
										name = L["Show Latency"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									showSafezone = {
										order = 3,
										name = L["Show Safe Zone"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									classcolor = {
										order = 4,
										name = L["Castbar Class Color"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										width = "full",
										disabled = function() return not db.nUnitframes.enable end,
									},									
									safezoneColor = {
										order = 5,
										type = "color",										
										name = L["Safe Zone Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.player.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local szc = db.nUnitframes.units.player.castbar[ info[#info] ]
											return szc.r, szc.g, szc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.player.castbar[ info[#info] ] = {}
											local szc = db.nUnitframes.units.player.castbar[ info[#info] ]
											szc.r, szc.g, szc.b = r, g, b
										end,					
									},											
									color = {
										order = 6,
										type = "color",
										width = "double",
										name = L["Castbar Custom Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.player.castbar.show or not db.nUnitframes.enable or db.nUnitframes.units.player.castbar.classcolor end,
										get = function(info)
											local cc = db.nUnitframes.units.player.castbar[ info[#info] ]
											return cc.r, cc.g, cc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.player.castbar[ info[#info] ] = {}
											local cc = db.nUnitframes.units.player.castbar[ info[#info] ]
											cc.r, cc.g, cc.b = r, g, b
										end,					
									},
									width= {
										order = 7,
										name = L["Castbar Width"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 8,
										name = L["Castbar Height"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 9,
										name = L["Castbar Scale"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},									
									icon = {
										type = "group",
										order = 10,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.player.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.player.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											show = {
												order = 1,
												name = L["Show Castbar Icon"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												width = "double",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 2,
												name = L["Position Icon Outside"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 3,
												name = L["Icon Position"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												style = "radio",
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
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.player.castbar.position[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.player.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 2,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 3,
												name = L["Rel Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},
											sep1 = {
												order = 4,
												type = "description",
												name = " ",						
											},											
											offSetX = {
												order = 5,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											offSetY = {
												order = 6,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
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
						order = 2,
						name = L["Pet"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.pet[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.pet[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							auraSize= {
								order = 2,
								name = L["Aura Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 10, max = 40, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 4,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showPowerPercent = {
								order = 5,
								name = L["Show Power Percent"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 6,
								name = L["Pet Position"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.pet.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.pet.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {							
									offSetX = {
										order = 1,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 2,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 7,
								name = L["Pet Castbar"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.pet.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.pet.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 1,
										name = L["Show Pet Castbar"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										
										disabled = function() return not db.nUnitframes.enable end,
									},
									width= {
										order = 2,
										name = L["Pet Castbar Width"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 3,
										name = L["Pet Castbar Height"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 4,
										name = L["Pet Castbar Scale"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},
									color = {
										order = 5,
										type = "color",
										name = L["Pet Castbar Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.pet.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local pcc = db.nUnitframes.units.pet.castbar[ info[#info] ]
											return pcc.r, pcc.g, pcc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.pet.castbar[ info[#info] ] = {}
											local pcc = db.nUnitframes.units.pet.castbar[ info[#info] ]
											pcc.r, pcc.g, pcc.b = r, g, b
										end,					
									},
									icon = {
										type = "group",
										order = 6,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.pet.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.pet.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											show = {
												order = 1,
												name = L["Show Pet Frame Castbar Icon"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 2,
												name = L["Position Icon Outside"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 3,
												name = L["Icon Position"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
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
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.pet.castbar.position[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.pet.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {
											selfAnchor = {
												order = 1,
												name = L["Self Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},
											relAnchor = {
												order = 2,
												name = L["Rel Anchor"],
												--desc = L["Style of Border for Sqaure Minimap."],
												disabled = function() return not db.nUnitframes.enable end,
												type = "select",
												values = N.regions;
											},							
											offSetX = {
												order = 3,
												name = L["Off Set X"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											offSetY = {
												order = 4,
												name = L["Off Set Y"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = -100, max = 100, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
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
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					target = {
						type = "group",
						order = 3,
						name = L["Target"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.target[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.target[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								min = 0.500, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numBuffs= {
								order = 2,
								name = L["Number of Buffs"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 0, max = 8, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numDebuffs= {
								order = 3,
								name = L["Number of Debuffs"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 0, max = 8, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							colorPlayerDebuffsOnly = {
								order = 4,
								name = L["Color Player Debuffs Only"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showAllTimers = {
								order = 5,
								name = L["Show All Timers"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableAura = {
								order = 6,
								name = L["Disable Aura"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showComboPoints = {
								order = 7,
								name = L["Show Combo Points"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showComboPointsAsNumber = {
								order = 8,
								name = L["Show Combo Points As Number"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							numComboPointsColor = {
								order = 9,
								type = "color",
								name = L["Number Combo Points Color"],
								--desc = L["Picks a Custom Color for the tooltip border."],
								hasAlpha = false,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info)
									local ncpc = db.nUnitframes.units.target[ info[#info] ]
									return ncpc.r, ncpc.g, ncpc.b
								end,
								set = function(info, r, g, b)
									db.nUnitframes.units.target[ info[#info] ] = {}
									local ncpc = db.nUnitframes.units.target[ info[#info] ]
									ncpc.r, ncpc.g, ncpc.b = r, g, b
								end,					
							},
							mouseoverText = {
								order = 10,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 11,
								name = L["Show Combat Feedback"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							icon = {
								type = "group",
								order = 10,
								name = L["Castbar Icon"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.target.castbar.icon[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.target.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {											
									show = {
										order = 1,
										name = L["Show Target Castbar Icon"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									positionOutside = {
										order = 2,
										name = L["Position Icon Outside"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									position = {
										order = 2,
										name = L["Icon Position"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
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
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.target.castbar.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.target.castbar.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									selfAnchor = {
										order = 2,
										name = L["Self Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 3,
										name = L["Rel Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},							
									offSetX = {
										order = 4,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 5,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
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
						order = 4,
						name = L["Target of Target"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.targettarget[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.targettarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							disableAura = {
								order = 2,
								name = L["Disable Aura"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 3,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					focus = {
						type = "group",
						order = 5,
						name = L["Focus"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.focus[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.focus[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							numDebuffs= {
								order = 2,
								name = L["Number of Debuffs"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								min = 0, max = 10, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 3,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showPowerPercent = {
								order = 4,
								name = L["Show Power Percent"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							showCombatFeedback = {
								order = 5,
								name = L["Show Combat Feedback"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							enableFocusToggleKeybind = {
								order = 6,
								name = L["Enable Focus Toggle Keybind"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							focusToggleKey = {
								order = 7,
								name = L["Focus Toggle Key"],
								--desc = L["Style of Border for Sqaure Minimap."],
								disabled = function() return not db.nUnitframes.enable end,
								type = "select",
								values = N.type;
							},
							castbar = {
								type = "group",
								order = 8,
								name = L["Focus Castbar"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.focus.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.focus.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 1,
										name = L["Show Focus Castbar"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},
									width= {
										order = 2,
										name = L["Focus Castbar Width"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 250, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									height= {
										order = 3,
										name = L["Focus Castbar Height"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									scale= {
										order = 4,
										name = L["Focus Castbar Scale"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 2, step = 0.001,
										disabled = function() return not db.nUnitframes.enable end,
									},
									color = {
										order = 5,
										type = "color",
										name = L["Focus Castbar Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.focus.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local fcc = db.nUnitframes.units.focus.castbar[ info[#info] ]
											return fcc.r, fcc.g, fcc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.focus.castbar[ info[#info] ] = {}
											local fcc = db.nUnitframes.units.focus.castbar[ info[#info] ]
											fcc.r, fcc.g, fcc.b = r, g, b
										end,					
									},
									interruptColor = {
										order = 5,
										type = "color",
										name = L["Interrupt Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.focus.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local ic = db.nUnitframes.units.focus.castbar[ info[#info] ]
											return ic.r, ic.g, ic.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.focus.castbar[ info[#info] ] = {}
											local ic = db.nUnitframes.units.focus.castbar[ info[#info] ]
											ic.r, ic.g, ic.b = r, g, b
										end,					
									},
									icon = {
										type = "group",
										order = 6,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.focus.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.focus.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											show = {
												order = 1,
												name = L["Show Icon"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											positionOutside = {
												order = 2,
												name = L["Position Outside"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 3,
												name = L["Icon Position"],
												--desc = L["Style of Border for Sqaure Minimap."],
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
						order = 6,
						name = L["Focus Target"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.focustarget[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.focustarget[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 2,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
						},
					},
					party = {
						type = "group",
						order = 7,
						name = L["Party"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.party[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.party[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							show = {
								order = 2,
								name = L["Show"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 3,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							hideInRaid = {
								order = 4,
								name = L["Hide In Raid"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Party Frame Position"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.party.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.party.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									selfAnchor = {
										order = 1,
										name = L["Self Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},							
									offSetX = {
										order = 2,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 3,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
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
						order = 8,
						name = L["Boss"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.boss[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.boss[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
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
								
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 2,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 3,
								name = L["Boss Frame Position"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.boss.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.boss.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									selfAnchor = {
										order = 1,
										name = L["Self Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 2,
										name = L["Rel Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},											
									offSetX = {
										order = 3,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 4,
								name = L["Boss Castbar"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.boss.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.boss.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 0,
										name = L["Show Castbar"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},								
									color = {
										order = 1,
										type = "color",
										name = L["Castbar Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.boss.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local bcc = db.nUnitframes.units.boss.castbar[ info[#info] ]
											return bcc.r, bcc.g, bcc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.boss.castbar[ info[#info] ] = {}
											local bcc = db.nUnitframes.units.boss.castbar[ info[#info] ]
											bcc.r, bcc.g, bcc.b = r, g, b
										end,					
									},
									icon = {
										type = "group",
										order = 2,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.boss.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.boss.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											show = {
												order = 1,
												name = L["Show Icon"],
												--desc = L["Use the Custom Color you have chosen."],
												type = "toggle",
												disabled = function() return not db.nUnitframes.enable end,
											},
											size = {
												order = 2,
												name = L["Icon Size"],
												--desc = L["Controls the width of power."],
												type = "range",
												min = 8, max = 50, step = 1,
												disabled = function() return not db.nUnitframes.enable end,
											},
											position = {
												order = 3,
												name = L["Icon Position"],
												--desc = L["Style of Border for Sqaure Minimap."],
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
						order = 9,
						name = L["Arena"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nUnitframes.enable end,
						get = function(info) return db.nUnitframes.units.arena[ info[#info] ] end,
						set = function(info, value) db.nUnitframes.units.arena[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							intro = {
								order = 0,
								type = "description",
								name = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Arena Frame."],
							},
							show = {
								order = 1,
								name = L["Show Arena Frames"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},									
							scale= {
								order = 2,
								name = L["Arena Frame Scale"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 0.5, max = 2, step = 0.001,
								disabled = function() return not db.nUnitframes.enable end,
							},
							auraSize= {
								order = 3,
								name = L["Aura Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",								
								min = 5, max = 50, step = 1,
								disabled = function() return not db.nUnitframes.enable end,
							},
							mouseoverText = {
								order = 4,
								name = L["Mouseover Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nUnitframes.enable end,
							},
							position = {
								type = "group",
								order = 5,
								name = L["Arena Frame Position"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.arena.position[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.arena.position[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									selfAnchor = {
										order = 1,
										name = L["Self Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},
									relAnchor = {
										order = 2,
										name = L["Rel Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nUnitframes.enable end,
										type = "select",
										values = N.regions;
									},											
									offSetX = {
										order = 3,
										name = L["Off Set X"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
									offSetY = {
										order = 4,
										name = L["Off Set Y"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = -100, max = 100, step = 1,
										disabled = function() return not db.nUnitframes.enable end,
									},
								},
							},
							castbar = {
								type = "group",
								order = 6,
								name = L["Arena Castbar"],
								--desc = L["Combo Points Options"],	
								guiInline = true,
								disabled = function() return not db.nUnitframes.enable end,
								get = function(info) return db.nUnitframes.units.arena.castbar[ info[#info] ] end,
								set = function(info, value) db.nUnitframes.units.arena.castbar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 0,
										name = L["Show Castbar"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										disabled = function() return not db.nUnitframes.enable end,
									},									
									color = {
										order = 1,
										type = "color",
										name = L["Castbar Color"],
										--desc = L["Picks a Custom Color for the tooltip border."],
										hasAlpha = false,
										disabled = function() return not db.nUnitframes.units.arena.castbar.show or not db.nUnitframes.enable end,
										get = function(info)
											local acc = db.nUnitframes.units.arena.castbar[ info[#info] ]
											return acc.r, acc.g, acc.b
										end,
										set = function(info, r, g, b)
											db.nUnitframes.units.arena.castbar[ info[#info] ] = {}
											local acc = db.nUnitframes.units.arena.castbar[ info[#info] ]
											acc.r, acc.g, acc.b = r, g, b
										end,					
									},
									icon = {
										type = "group",
										order = 2,
										name = L["Castbar Icon"],
										--desc = L["Combo Points Options"],	
										guiInline = true,
										disabled = function() return not db.nUnitframes.enable end,
										get = function(info) return db.nUnitframes.units.arena.castbar.icon[ info[#info] ] end,
										set = function(info, value) db.nUnitframes.units.arena.castbar.icon[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
										args = {											
											size = {
												order = 1,
												name = L["Icon Size"],
												--desc = L["Controls the width of power."],
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
				order = 9,
				type = "group",
				name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid"],
				--desc = L["Options for oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|rRaid."],
				get = function(info) return db.nRaidframes[ info[#info] ] end,
				set = function(info, value) db.nRaidframes[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,
				args = {		
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
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid Font"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nRaidframes.enable end,
						get = function(info) return db.nRaidframes.font[ info[#info] ] end,
						set = function(info, value) db.nRaidframes.font[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							fontSmallSize = {
								order = 1,
								name = L["Font Small Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							fontBigSize = {
								order = 2,
								name = L["Font Big Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 8, max = 25, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
						},
					},							
					raid = {
						type = "group",
						order = 1,
						name = L["oUF_|cffCC3333N|r|cffE53300e|r|cffFF4D00a|r|cffFF6633v|r Raid"],
						--desc = L["Custom Coloring"],
						disabled = function() return not db.nRaidframes.enable end,
						get = function(info) return db.nRaidframes.units.raid[ info[#info] ] end,
						set = function(info, value) db.nRaidframes.units.raid[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
						args = {
							showSolo = {
								order = 2,
								name = L["Show Solo"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showParty = {
								order = 3,
								name = L["Show in Party"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							nameLength= {
								order = 4,
								name = L["Name Length"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 2, max = 20, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							width= {
								order = 5,
								name = L["Width"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							height= {
								order = 6,
								name = L["Height"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							scale= {
								order = 7,
								name = L["Raid Frame Scale"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 0.5, max = 2, step = 0.1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							layout = {
								type = "group",
								order = 8,
								name = L["Raid Frame Layout"],
								--desc = L["Combo Points Options"],	
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info) return db.nRaidframes.units.raid.layout[ info[#info] ] end,
								set = function(info, value) db.nRaidframes.units.raid.layout[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {						
									frameSpacing = {
										order = 1,
										name = L["Frame Spacing"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 50, step = 1,
										disabled = function() return not db.nRaidframes.enable end,
									},
									numGroups = {
										order = 2,
										name = L["Number of Groups"],
										--desc = L["Controls the width of power."],
										type = "range",
										min = 0, max = 8, step = 1,
										disabled = function() return not db.nRaidframes.enable end,
									},
									initialAnchor = {
										order = 3,
										name = L["Initial Anchor"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nRaidframes.enable end,
										type = "select",
										values = N.regions;
									},
									orientation = {
										order = 4,
										name = L["Orientation"],
										--desc = L["Style of Border for Sqaure Minimap."],
										disabled = function() return not db.nRaidframes.enable end,
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
								disabled = function() return not db.nRaidframes.enable end,
							},
							showThreatText = {
								order = 10,
								name = L["Show Threat Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showRolePrefix = {
								order = 11,
								name = L["Show Role Prefix"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showNotHereTimer = {
								order = 12,
								name = L["Show Not Here Timer"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showMainTankIcon = {
								order = 13,
								name = L["Show Main Tank Icon"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showResurrectText = {
								order = 14,
								name = L["Show Resurrect Text"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showMouseoverHighlight = {
								order = 15,
								name = L["Show Mouseover Highlight"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							showTargetBorder = {
								order = 16,
								name = L["Show Target Border"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							targetBorderColor = {
								order = 17,
								type = "color",
								name = L["Target Border Color"],
								--desc = L["Picks a Custom Color for the tooltip border."],
								hasAlpha = false,
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info)
									local tbc = db.nRaidframes.units.raid[ info[#info] ]
									return tbc.r, tbc.g, tbc.b
								end,
								set = function(info, r, g, b)
									db.nRaidframes.units.raid[ info[#info] ] = {}
									local tbc = db.nRaidframes.units.raid[ info[#info] ]
									tbc.r, tbc.g, tbc.b = r, g, b
								end,					
							},
							iconSize = {
								order = 18,
								name = L["Debuff Icon Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 10, max = 50, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},
							indicatorSize = {
								order = 19,
								name = L["Indicator Size"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 0, max = 20, step = 1,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							horizontalHealthBars = {
								order = 20,
								name = L["Horizontal Health Bars"],
								--desc = L["Use the Custom Color you have chosen."],
								type = "toggle",
								disabled = function() return not db.nRaidframes.enable end,
							},
							deficitThreshold= {
								order = 21,
								name = L["Deficit Threshold"],
								--desc = L["Controls the healthbar value font size."],
								type = "range",
								
								min = 0.05, max = 1, step = 0.05,
								disabled = function() return not db.nRaidframes.enable end,
							},									
							manabar = {
								type = "group",
								order = 22,
								name = L["Raid Manabar"],
								--desc = L["Combo Points Options"],	
								disabled = function() return not db.nRaidframes.enable end,
								get = function(info) return db.nRaidframes.units.raid.manabar[ info[#info] ] end,
								set = function(info, value) db.nRaidframes.units.raid.manabar[ info[#info] ] = value; StaticPopup_Show("CFG_RELOAD") end,						
								args = {
									show = {
										order = 1,
										name = L["Show"],
										--desc = L["Use the Custom Color you have chosen."],
										type = "toggle",
										
										disabled = function() return not db.nRaidframes.enable end,
									},
									horizontalOrientation = {
										order = 2,
										name = L["Horizontal Orientation"],
										--desc = L["Use the Custom Color you have chosen."],
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

function NeavUIConfig:SetDefaultOptions()
	local N, _, _ = unpack(NeavUI)
	local addon = self.db.profile;
	addon.nMedia = {
		font = "Express Freeway",
		fontSmall = "Small",
		fontThick = "Thick",	
		fontVisitor = "Visitor",	
		fontNumber = "Number",	
	}	
	addon.nBuff = {
		enable = true,
		buffSize = 36,
		buffScale = 1,
		buffBorderColor = {r = 1, g = 1, b = 1}, 

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
	addon.nChat = {
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
	addon.nCore = {
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
	addon.nMainbar = {	
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
	addon.nMinimap = {
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
	addon.nPlates = {
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
	addon.nPower = {
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
	addon.nTooltip = {											
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
	addon.nUnitframes = {
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
	addon.nRaidframes = {
		enable = false,
		media = {
			statusbar = 'Interface\\AddOns\\NeavUI\\nMedia\\nTextures\\statusbarTexture',                 -- Health- and Powerbar texture
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