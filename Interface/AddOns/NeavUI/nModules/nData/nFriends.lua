local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database
local LibQTip = LibStub('LibQTip-1.0')	-- tooltip library
local tooltip

--[[

	All Credit for Friends.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if not C['nData'].friends or C['nData'].friends == 0 then return end

-- create a popup
StaticPopupDialogs.SET_BN_BROADCAST = {
	text = BN_BROADCAST_TOOLTIP,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	editBoxWidth = 350,
	maxLetters = 127,
	OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
	OnShow = function(self) self.editBox:SetText(select(3, BNGetInfo()) ) self.editBox:SetFocus() end,
	OnHide = ChatEdit_FocusActiveWindow,
	EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

-- localized references for global functions (about 50% faster)
local join 			= string.join
local find			= string.find
local format		= string.format
local split			= string.split
local sort			= table.sort
local insert		= table.insert
local sizeof		= table.getn

-- for Data display
local displayString = join("", hexa.."%s: "..hexb, "|cffffffff", "%d|r")

local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("MEDIUM")
Stat:SetFrameLevel(3)

local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
N.PP(C['nData'].friends, Text)

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
	FACTION		=	function(a, b)
						if a["FACTION"] < b["FACTION"] then
							return true
						elseif a["FACTION"] > b["FACTION"] then
							return false
						else  -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
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
	ZONENAME	=	function(a, b)
						if a["ZONENAME"] < b["ZONENAME"] then
							return true
						elseif a["ZONENAME"] > b["ZONENAME"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	REALMNAME	=	function(a, b)
						if a["REALMNAME"] < b["REALMNAME"] then
							return true
						elseif a["REALMNAME"] > b["REALMNAME"] then
							return false
						else -- TOONNAME
							return a["ZONENAME"] < b["ZONENAME"]
						end
					end,
	revTOONNAME	=	function(a, b)
						return a["TOONNAME"] > b["TOONNAME"]
					end,
	revFACTION	=	function(a, b)
						if a["FACTION"] < b["FACTION"] then
							return true
						elseif a["FACTION"] > b["FACTION"] then
							return false
						else  -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
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
	revZONENAME	=	function(a, b)
						if a["ZONENAME"] > b["ZONENAME"] then
							return true
						elseif a["ZONENAME"] < b["ZONENAME"] then
							return false
						else -- TOONNAME
							return a["TOONNAME"] < b["TOONNAME"]
						end
					end,
	revREALMNAME	=	function(a, b)
						if a["REALMNAME"] > b["REALMNAME"] then
							return true
						elseif a["REALMNAME"] < b["REALMNAME"] then
							return false
						else -- TOONNAME
							return a["ZONENAME"] < b["ZONENAME"]
						end
					end
}

local function SetRealIDSort(cell, sortsection)
	if C['nData'].fsort == sortsection then
		C['nData'].fsort = "rev" .. sortsection
	else
		C['nData'].fsort = sortsection
	end
	FriendEnter(Stat)
end

local function EventHandler(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local NumFriends, online = GetNumFriends()
		local realidTotal, realidOnline = BNGetNumFriends()
		displayline = online + realidOnline
		Text:SetFormattedText(displayString, "Friends", displayline)
		self:SetAllPoints(Text)
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

----------------------------
--  If names are clicked  --
----------------------------

local function Entry_OnMouseUp(frame, info, button)
	local i_type, toon_name, full_name, presence_id = split(":", info)

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
			if i_type == "friends" then
				FriendsFrame.NotesID = player_name_to_index(toon_name)
 				StaticPopup_Show("SET_FRIENDNOTE", GetFriendInfo(FriendsFrame.NotesID))
 				return
			end

			if i_type == "realid" then
				FriendsFrame.NotesID = presence_id
				StaticPopup_Show("SET_BNFRIENDNOTE", full_name)
				return
			end
		-- Send a tell to player
		else
			SetItemRef("player:"..full_name, "|Hplayer:"..full_name.."|h["..full_name.."|h", "LeftButton")
		end
	elseif button == "RightButton" then
		-- Expand RealID Broadcast
		C['nData'].showbroadcast = not C['nData'].showbroadcast
		FriendEnter(Stat)
	end
end
	
Stat:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then 
		ToggleFriendsFrame(1)
	elseif button == "RightButton" then
		StaticPopup_Show("SET_BN_BROADCAST")
	end
end)

------------------------
--      Tooltip!      --
------------------------
local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local AWAY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-Away:18|t"
local BUSY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-DnD:18|t"
local MINIMIZE		= "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"
local BROADCAST_ICON = "|TInterface\\FriendsFrame\\BroadcastIcon:0|t"
local HORDE_FACTION = "|TInterface\\BattlefieldFrame\\Battleground-Horde:18|t"
local ALLIANCE_FACTION = "|TInterface\\BattlefieldFrame\\Battleground-Alliance:18|t"


local function ColoredLevel(level)
	if level ~= "" then
		local color = GetQuestDifficultyColor(level)
		return format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local CLASS_COLORS, color = {}
local classes_female, classes_male = {}, {}

FillLocalizedClassList(classes_female, true)
FillLocalizedClassList(classes_male, false)

for token, localizedName in pairs(classes_female) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

for token, localizedName in pairs(classes_male) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

function FriendEnter(self)
	if InCombatLockdown() then return end

	if LibQTip:IsAcquired("FriendList") then
		tooltip:Clear()
	else
		local _, panel, _, _ = N.DataTooltipAnchor(Text)	-- to properly place the tooltip
		tooltip = LibQTip:Acquire("FriendList", 7, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")
		self.tooltip = tooltip
		tooltip:SetBackdropColor(0,0,0,1)
		tooltip:SetHeaderFont(ssHeaderFont)
		tooltip:SetFont(ssRegFont)
		tooltip:SmartAnchorTo(panel)
		tooltip:SetAutoHideDelay(0.1, self)
	end

	-------------------------
	--  Begin RealID list  --
	-------------------------
	local numBNFriends, numBNOnline = BNGetNumFriends()
	local numFriends, numFriendsOnline = GetNumFriends()
	local totalOnlineFriends, totalFriends = numBNOnline + numFriendsOnline, numBNFriends + numFriends

	if (numBNOnline > 0) or (numFriendsOnline > 0) then
		-- Header for Friends
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, hexa..N.myname.."'s "..hexb.."|cff00ff00Friend Info|r", "CENTER", 0)		
		
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, "|cffffffff" .. _G.FRIENDS .. "|r", "LEFT", 3)
		tooltip:SetCell(line, 7, "|cffffffff" .. totalOnlineFriends .. " of " .. totalFriends .. "|r Online", "RIGHT")

		line = tooltip:AddHeader()
		line = tooltip:SetCell(line, 1, _G.LEVEL, "CENTER")
		tooltip:SetCellScript(line, 1, "OnMouseUp", SetRealIDSort, "LEVEL")		
		line = tooltip:SetCell(line, 3, _G.NAME, "CENTER")
		tooltip:SetCellScript(line, 3, "OnMouseUp", SetRealIDSort, "TOONNAME")
		line = tooltip:SetCell(line, 4, _G.BATTLENET_FRIEND, "CENTER")
		line = tooltip:SetCell(line, 5, _G.LOCATION_COLON, "CENTER")
		tooltip:SetCellScript(line, 5, "OnMouseUp", SetRealIDSort, "ZONENAME")
		line = tooltip:SetCell(line, 6, _G.FRIENDS_LIST_REALM, "CENTER")
		tooltip:SetCellScript(line, 6, "OnMouseUp", SetRealIDSort, "REALMNAME")

		line = tooltip:SetCell(line, 7, _G.NOTE_COLON, "CENTER")

		tooltip:AddSeparator()

		if numBNOnline > 0 then
			local realid_table = {}
			for i = 1, numBNOnline do
				local presenceID, givenName, surname = BNGetFriendInfo(i)
				for toonidx = 1, BNGetNumFriendToons(i) do
					local fcolor = ""
					local status = ""

					local _, _, _, _, _, _, isOnline, lastOnline, isAFK, isDND, broadcast, note = BNGetFriendInfoByID(presenceID)
					local _, toonName, client, realmName, _, faction, race, class, guild, zoneName, level, gameText = BNGetFriendToonInfo(i, toonidx)

					if faction then
						if faction == 0 then
							fcolor = HORDE_FACTION
						else
							fcolor = ALLIANCE_FACTION
						end
					end

					if isAFK then
						status = AWAY_ICON
					end

					if isDND then
						status = BUSY_ICON
					end

					if note and note ~= "" then note = "|cffff8800{"..note.."}|r" end
					
					insert(realid_table, {
						GIVENNAME = givenName,
						SURNAME = surname,
						LEVEL = level,
						CLASS = class,
						FCOLOR = fcolor,
						STATUS = status,
						BROADCAST_TEXT = broadcast,
						TOONNAME = toonName,
						CLIENT = client,
						ZONENAME = zoneName,
						REALMNAME = realmName,
						GAMETEXT = gameText,
						NOTE = note,
						PRESENCEID = presenceID
						})
				end
			end
			
			if not C['nData'].fsort or C['nData'].fsort == "" then
				sort(realid_table, list_sort["TOONNAME"])
			else
				sort(realid_table, list_sort[C['nData'].fsort])
			end

			for _, player in ipairs(realid_table) do
				local broadcast_flag
				if C['nData'].showbroadcast == true and player["BROADCAST_TEXT"] ~= "" then
					broadcast_flag = " " .. BROADCAST_ICON
				else
					broadcast_flag = ""
				end

				line = tooltip:AddLine()
				if player["CLIENT"] == "WoW" then
					line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]).." "..player["FCOLOR"])
				else
					line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
				end
				line = tooltip:SetCell(line, 2, player["STATUS"])
				line = tooltip:SetCell(line, 3,
					format("|cff%s%s",CLASS_COLORS[player["CLASS"]] or "B8B8B8", player["TOONNAME"] .. "|r")..
					(inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""))
				line = tooltip:SetCell(line, 4,
					"|cff82c5ff" .. player["GIVENNAME"] .. " " .. player["SURNAME"] .. "|r" .. broadcast_flag)

				if player["CLIENT"] == "WoW" then
					line = tooltip:SetCell(line, 5, player["ZONENAME"])
					line = tooltip:SetCell(line, 6, player["REALMNAME"])
				else
					line = tooltip:SetCell(line, 5, player["GAMETEXT"])
					if player["CLIENT"] == "S2" then
						line = tooltip:SetCell(line, 6, "|cff82c5ffStarCraft 2|r")
					end
				end
				
				line = tooltip:SetCell(line, 7, player["NOTE"])
				tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("realid:%s:%s %s:%d", player["TOONNAME"], player["GIVENNAME"], player["SURNAME"], player["PRESENCEID"]))
				
				if C['nData'].showbroadcast == true and player["BROADCAST_TEXT"] ~= "" then
					line = tooltip:AddLine()
					line = tooltip:SetCell(line, 1, BROADCAST_ICON .. " |cff7b8489" .. player["BROADCAST_TEXT"] .. "|r", "LEFT", 0)
					tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("realid:%s:%s %s:%d", player["TOONNAME"], player["GIVENNAME"], player["SURNAME"], player["PRESENCEID"]))
				end
			end
			tooltip:AddLine(" ")
		end

		if numFriendsOnline > 0 then
			local friend_table = {}
			for i = 1,numFriendsOnline do
				local toonName, level, class, zoneName, connected, status, note = GetFriendInfo(i)
				note = note and "|cffff8800{"..note.."}|r" or ""

				if status == CHAT_FLAG_AFK then
					status = AWAY_ICON
				elseif status == CHAT_FLAG_DND then
					status = BUSY_ICON
				end

				insert(friend_table, {
					TOONNAME = toonName,
					LEVEL = level,
					CLASS = class,
					ZONENAME = zoneName,
					REALMNAME = "",
					STATUS = status,
					NOTE = note
					})
			end
			
			if not C['nData'].fsort or C['nData'].fsort == "" then
				sort(friend_table, list_sort["TOONNAME"])
			else
				sort(friend_table, list_sort[C['nData'].fsort])
			end

			for _, player in ipairs(friend_table) do
				line = tooltip:AddLine()
				line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
				line = tooltip:SetCell(line, 2, player["STATUS"])
				line = tooltip:SetCell(line, 3,
					format("|cff%s%s", CLASS_COLORS[player["CLASS"]] or "ffffff", player["TOONNAME"] .. "|r") .. (inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""));
				line = tooltip:SetCell(line, 5, player["ZONENAME"])
				line = tooltip:SetCell(line, 7, player["NOTE"])

				tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, format("friends:%s:%s", player["TOONNAME"], player["TOONNAME"]))
			end
		end
		tooltip:AddLine(" ")
	else
		-- no one online
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, "|cffff0000No Friends Online!|r", "CENTER", 0)
	end


	------------------
	--  HINT HINT!  --
	------------------
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fLeft-Click|r to open the friend panel.    |cffeda55fRight-Click|r to set a broadcast message.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fLeft-Click|r a line to whisper a player.  |cffeda55fRight-Click|r a line to expand broadcast message.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fCtrl-Click|r a line to edit a note.    |cffeda55fShift-Click|r a line to lookup a player.", "LEFT", 0)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|cffeda55fAlt-Click|r a line to invite.    |cffeda55fClick|r a Header to sort it.", "LEFT", 0)

	tooltip:UpdateScrolling()
	
	-- set the look of the tooltip
	tooltip:Show()	
end

Stat:SetScript("OnEnter", FriendEnter)
--[[Stat:SetScript("OnLeave", function(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end)]]

local DELAY = 15  --  Update every 15 seconds
local elapsed = DELAY - 5

Stat:SetScript("OnUpdate", function (self, el)
	elapsed = elapsed + el

	if elapsed >= DELAY then
		elapsed = 0
		local NumFriends, online = GetNumFriends()
		local realidTotal, realidOnline = BNGetNumFriends()
		displayline = online + realidOnline
		Text:SetFormattedText(displayString, "Friends", displayline)
		self:SetAllPoints(Text)
	end
end)

Stat:RegisterEvent("PLAYER_ENTERING_WORLD")


Stat:SetScript("OnLeave", function() end)
Stat:SetScript("OnEvent", EventHandler)
