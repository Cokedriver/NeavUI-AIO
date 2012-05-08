local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database
local LibQTip = LibStub('LibQTip-1.0')	-- tooltip library
local tooltip

--[[

	All Credit for Guild.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if not C['nData'].guild or C['nData'].guild == 0 then return end

-- localized references for global functions (about 50% faster)
local join 			= string.join
local format		= string.format
local find			= string.find
local gsub			= string.gsub
local sort			= table.sort
local insert		= table.insert
local ceil			= math.ceil
local sizeof		= table.getn
local displayString = join("", hexa.."%s: "..hexb, ": ", "%d|r")
local noGuildString = join("", hexa.."No Guild"..hexb)

-------------------------------------------------------------------------------
-- Font definitions.
-------------------------------------------------------------------------------
-- Setup the Title Font. 14
local ssTitleFont = CreateFont("ssTitleFont")
ssTitleFont:SetTextColor(1,0.823529,0)
ssTitleFont:SetFont(GameTooltipText:GetFont(), 20)

-- Setup the Header Font. 12
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)
ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont(), 15)

-- Setup the Regular Font. 12
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)
ssRegFont:SetFont(GameTooltipText:GetFont(), 15)

local list_sort = {
	TOONNAME	=	function(a, b)
						return a["TOONNAME"] < b["TOONNAME"]
					end,
	LEVEL		=	function(a, b)
						if a["LEVEL"] < b["LEVEL"] then
							return true
						elseif a["LEVEL"] > b["LEVEL"] then
							return false
						else  -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	RANKINDEX	=	function(a, b)
						if a["RANKINDEX"] > b["RANKINDEX"] then
							return true
						elseif a["RANKINDEX"] < b["RANKINDEX"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	ZONENAME	=	function(a, b)
						if a["ZONENAME"] < b["ZONENAME"] then
							return true
						elseif a["ZONENAME"] > b["ZONENAME"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	revTOONNAME	=	function(a, b)
						return a["TOONNAME"] > b["TOONNAME"]
					end,
	revLEVEL		=	function(a, b)
						if a["LEVEL"] > b["LEVEL"] then
							return true
						elseif a["LEVEL"] < b["LEVEL"] then
							return false
						else  -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	revRANKINDEX	=	function(a, b)
						if a["RANKINDEX"] < b["RANKINDEX"] then
							return true
						elseif a["RANKINDEX"] > b["RANKINDEX"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	revZONENAME	=	function(a, b)
						if a["ZONENAME"] > b["ZONENAME"] then
							return true
						elseif a["ZONENAME"] < b["ZONENAME"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
}

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
N.PP(C['nData'].guild, Text)
Stat:SetAllPoints(Text)

------------------------
--	Helper Functions  --
------------------------
local function ColoredLevel(level)
	if level ~= "" then
		local color = GetQuestDifficultyColor(level)
		return string.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local function inGroup(name)
	if GetNumPartyMembers() > 0 and UnitInParty(name) then
		return true
	elseif GetNumRaidMembers() > 0 and UnitInRaid(name) then
		return true
	end

	return false
end

local function SetGuildSort(cell, sortsection)
	if C['nData'].gsort == sortsection then
		C['nData'].gsort = "rev" .. sortsection
	else
		C['nData'].gsort = sortsection
	end
	OnEnter(Stat)
end

local function EventHelper(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" and IsInGuild() then
		local _, online = GetNumGuildMembers()
		Text:SetFormattedText(displayString, online)
	else
		Text:SetText(noGuildString)
	end
end

----------------------------
--  If names are clicked  --
----------------------------

local function Entry_OnMouseUp(frame, info, button)
	local i_type, toon_name, full_name, presence_id = string.split(":", info)

	if button == "LeftButton" then
		-- Invite to group/raid
		if IsAltKeyDown() then
			InviteUnit(toon_name)
			return
		-- Lookup player via /who
		elseif IsShiftKeyDown() then
			SetItemRef("player:"..toon_name, "|Hplayer:"..toon_name.."|h["..toon_name.."|h", "LeftButton")
			return
		-- Edit Player Note
		elseif IsControlKeyDown() then
			if i_type == "guild" and CanEditPublicNote() then
				SetGuildRosterSelection(guild_name_to_index(toon_name))
				StaticPopup_Show("SET_GUILDPLAYERNOTE")
				return
			end
		-- Send a tell to player
		else 
			SetItemRef("player:"..full_name, "|Hplayer:"..full_name.."|h["..full_name.."|h", "LeftButton")
		end
	elseif button == "RightButton" then
		-- Edit Guild Officer Notes
		if IsControlKeyDown() then
			if i_type == "guild" and CanEditOfficerNote() then
				SetGuildRosterSelection(guild_name_to_index(toon_name))
				StaticPopup_Show("SET_GUILDOFFICERNOTE")
			end
		end
	end
end

------------------------
--      Tooltip!      --
------------------------
local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local AWAY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-Away:18|t"
local BUSY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-DnD:18|t"
local MINIMIZE		= "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"
local BROADCAST_ICON = "|TInterface\\FriendsFrame\\BroadcastIcon:0|t"
local MOBILE_ICON	= "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:18|t"

local FACTION_COLOR_HORDE = RED_FONT_COLOR_CODE
local FACTION_COLOR_ALLIANCE = "|cff0070dd"

local function ColoredLevel(level)
	if level ~= "" then
		local color = GetQuestDifficultyColor(level)
		return string.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local CLASS_COLORS, color = {}
local classes_female, classes_male = {}, {}

FillLocalizedClassList(classes_female, true)
FillLocalizedClassList(classes_male, false)

for token, localizedName in pairs(classes_female) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = string.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

for token, localizedName in pairs(classes_male) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = string.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

-- click the Data
Stat:SetScript("OnMouseUp", function() ToggleGuildFrame(1) end)

-- build and show the tooltip!
function OnEnter(self)
	if InCombatLockdown() then return end

	if LibQTip:IsAcquired("GuildList") then
		tooltip:Clear()
	else
		local _, panel, _, _ = N.DataTooltipAnchor(Text)	-- to properly place the tooltip
		tooltip = LibQTip:Acquire("GuildList", 7, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")
		self.tooltip = tooltip
		tooltip:SetBackdropColor(0,0,0,1)
		tooltip:SetHeaderFont(ssHeaderFont)
		tooltip:SetFont(ssRegFont)
		tooltip:SmartAnchorTo(panel)
		tooltip:SetAutoHideDelay(0.1, self)
	end

	------------------------
	--  Begin guild list  --
	------------------------

	if IsInGuild() then
		local guild_table = {}

		for i = 1, GetNumGuildMembers() do
			local toonName, rank, rankindex, level, class, zoneName, note, onote, connected, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i)

			if connected then
				if note and note ~= '' then note="|cff00ff00["..note.."]|r" end
				if onote and onote ~= '' then onote = "|cff00ffff["..onote.."]|r" end

				if status == CHAT_FLAG_AFK then
					status = AWAY_ICON
				elseif status == CHAT_FLAG_DND then
					status = BUSY_ICON
				elseif isMobile then
					status = MOBILE_ICON
					zoneName = "Remote Chat"
				end

				insert(guild_table, {
					TOONNAME = toonName,
					RANK = rank,
					RANKINDEX = rankindex,
					LEVEL = level,
					CLASS = class,
					ZONENAME = zoneName,
					NOTE = note,
					ONOTE = onote,
					STATUS = status
				})
			end
		end

		-- Header for Guild
		local guildName, guildLevel = GetGuildInfo("player"), GetGuildLevel()
		
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, hexa..N.myname.."'s "..hexb.."|cff00ff00Guild Info|r", "CENTER", 0)
		
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, "|cffffffff" .. guildName .."|r |cff00ff00[ Level " .. guildLevel .. " ]|r ", "LEFT",3)
		tooltip:SetCell(line, 7, "|cffffffff" .. sizeof(guild_table) .. " of " .. GetNumGuildMembers() .. "|r |cff00ff00Online|r", "RIGHT")

		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, "|cff00ff00"..GetGuildRosterMOTD().."|r", "LEFT", 0, nil, nil, nil, 100)

		line = tooltip:AddHeader()
		line = tooltip:SetCell(line, 1, _G.LEVEL, "CENTER")
		tooltip:SetCellScript(line, 1, "OnMouseUp", SetGuildSort, "LEVEL")
		line = tooltip:SetCell(line, 3, _G.NAME, "CENTER")
		tooltip:SetCellScript(line, 3, "OnMouseUp", SetGuildSort, "TOONNAME")
		line = tooltip:SetCell(line, 5, _G.ZONE, "CENTER")
		tooltip:SetCellScript(line, 5, "OnMouseUp", SetGuildSort, "ZONENAME")
		line = tooltip:SetCell(line, 6, _G.RANK, "CENTER")
		tooltip:SetCellScript(line, 6, "OnMouseUp", SetGuildSort, "RANKINDEX")
		line = tooltip:SetCell(line, 7, _G.NOTE, "CENTER")
		tooltip:AddSeparator()
		
		if not C['nData'].gsort then
			sort(guild_table, list_sort["TOONNAME"])
		else
			sort(guild_table, list_sort[C['nData'].gsort])
		end

		for _, player in ipairs(guild_table) do
			line = tooltip:AddLine()
			line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
			line = tooltip:SetCell(line, 2, player["STATUS"])
			line = tooltip:SetCell(line, 3,
				format("|cff%s%s", CLASS_COLORS[player["CLASS"]] or "ffffff", player["TOONNAME"] .. "|r") .. (inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""))
			line = tooltip:SetCell(line, 5, player["ZONENAME"] or "???")
			line = tooltip:SetCell(line, 6, player["RANK"])
			line = tooltip:SetCell(line, 7, player["NOTE"])
			tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("guild:%s:%s", player["TOONNAME"], player["TOONNAME"]))
		end
	end
	
	tooltip:AddLine(" ")

	------------------
	--  HINT HINT!  --
	------------------
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fAlt-Click|r to open the guild panel.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fClick|r a line to whisper a player.  |cffeda55fShift-Click|r a line to lookup a player.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fCtrl-Click|r a line to edit a note.    |cffeda55fCtrl-RightClick|r a line to edit an officer note.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fAlt-Click|r a line to invite.    |cffeda55fClick|r a Header to sort it.", "LEFT", 0)

	tooltip:UpdateScrolling()
	tooltip:Show()
end

Stat:SetScript("OnEnter", OnEnter)
--[[Stat:SetScript("OnLeave", function(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end)]]

local DELAY = 5  --  Update every 15 seconds
local elapsed = DELAY - 1

Stat:SetScript("OnUpdate", function (self, el)
	elapsed = elapsed + el

	if elapsed >= DELAY then
		elapsed = 0
		if IsInGuild() then
			local _, online = GetNumGuildMembers()
			Text:SetFormattedText(displayString, "Guild", online)
		else
			Text:SetText(noGuildString)
		end
	end
end)

Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:SetScript("OnEvent", EventHandler)
