local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database


--[[

	All Credit for Guild.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

---------
-- Guild
---------
if C['nData'].guild and C['nData'].guild > 0 then

	function RGBToHex(r, g, b)
		r = r <= 1 and r >= 0 and r or 0
		g = g <= 1 and g >= 0 and g or 0
		b = b <= 1 and b >= 0 and b or 0
		return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end

	ShortValue = function(v)
		if v >= 1e6 then
			return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
		elseif v >= 1e3 or v <= -1e3 then
			return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
		else
			return v
		end
	end

	function HexToRGB(hex)
		local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
		return tonumber(rhex, 16), tonumber(ghex, 16), tonumber(bhex, 16)
	end
	
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("MEDIUM")
	Stat:SetFrameLevel(3)

	local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	N.PP(C['nData'].guild, Text)

	local tthead, ttsubh, ttoff = {r=0.4, g=0.78, b=1}, {r=0.75, g=0.9, b=1}, {r=.3,g=1,b=.3}
	local activezone, inactivezone = {r=0.3, g=1.0, b=0.3}, {r=0.65, g=0.65, b=0.65}
	local displayString = string.join("", hexa.."%s: "..hexb, "|cffffffff", "%d|r")
	local guildInfoString0 = "%s"
	local guildInfoString1 = "%s [%d]"
	local guildInfoString2 = "%s: %d/%d"
	local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
	local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
	local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
	local nameRankString = "%s |cff999999-|cffffffff %s"
	local noteString = "  '%s'"
	local officerNoteString = "  o: '%s'"

	local guildTable, guildXP, guildMotD = {}, {}, ""
	local totalOnline = 0


	local function BuildGuildTable()
		totalOnline = 0
		wipe(guildTable)
		local _, name, rank, level, zone, note, officernote, connected, status, class, isMobile
		for i = 1, GetNumGuildMembers() do
			name, rank, _, level, _, zone, note, officernote, connected, status, class, _, _, isMobile = GetGuildRosterInfo(i)
			
			if status == 1 then
				status = "|cffff0000["..AFK.."]|r"
			elseif status == 2 then
				status = "|cffff0000["..DND.."]|r" 
			else
				status = ""
			end
			
			guildTable[i] = { name, rank, level, zone, note, officernote, connected, status, class, isMobile }
			if connected then totalOnline = totalOnline + 1 end
		end
		table.sort(guildTable, function(a, b)
			if a and b then
				return a[1] < b[1]
			end
		end)
	end

	local function UpdateGuildXP()
		local currentXP, remainingXP = UnitGetGuildXP("player")
		local nextLevelXP = currentXP + remainingXP
		
		-- prevent 4.3 division / 0
		if nextLevelXP == 0 or maxDailyXP == 0 then return end
		
		local percentTotal = tostring(math.ceil((currentXP / nextLevelXP) * 100))
		
		guildXP[0] = { currentXP, nextLevelXP, percentTotal }
	end

	local function UpdateGuildMessage()
		guildMotD = GetGuildRosterMOTD()
	end

	local function Update(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if IsInGuild() and not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
		end
		
		if IsInGuild() then
			totalOnline = 0
			local name, rank, level, zone, note, officernote, connected, status, class
			for i = 1, GetNumGuildMembers() do
				local connected = select(9, GetGuildRosterInfo(i))
				if connected then totalOnline = totalOnline + 1 end
			end	
			Text:SetFormattedText(displayString, "Guild", totalOnline)
		else
			Text:SetText("No Guild")
		end
		
		self:SetAllPoints(Text)
	end
		
	local menuFrame = CreateFrame("Frame", "GuildRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
		{ text = INVITE, hasArrow = true,notCheckable=true,},
		{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true,}
	}

	local function inviteClick(self, arg1, arg2, checked)
		menuFrame:Hide()
		InviteUnit(arg1)
	end

	local function whisperClick(self,arg1,arg2,checked)
		menuFrame:Hide()
		SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
	end

	local function ToggleGuildFrame()
		if IsInGuild() then 
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end 
			GuildFrame_Toggle()
			GuildFrame_TabClicked(GuildFrameTab2)
		else 
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end 
			LookingForGuildFrame_Toggle() 
		end
	end

	Stat:SetScript("OnMouseUp", function(self, btn)
		if btn ~= "RightButton" or not IsInGuild() then return end
		
		GameTooltip:Hide()

		local classc, levelc, grouped
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for i = 1, #guildTable do
			if (guildTable[i][7] and guildTable[i][1] ~= nDatamyname) then
				local classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[guildTable[i][9]], GetQuestDifficultyColor(guildTable[i][3])

				if UnitInParty(guildTable[i][1]) or UnitInRaid(guildTable[i][1]) then
					grouped = "|cffaaaaaa*|r"
				else
					grouped = ""
					if not guildTable[i][10] then
						menuCountInvites = menuCountInvites + 1
						menuList[2].menuList[menuCountInvites] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], ""), arg1 = guildTable[i][1],notCheckable=true, func = inviteClick}
					end
				end
				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] = {text = string.format(levelNameString, levelc.r*255,levelc.g*255,levelc.b*255, guildTable[i][3], classc.r*255,classc.g*255,classc.b*255, guildTable[i][1], grouped), arg1 = guildTable[i][1],notCheckable=true, func = whisperClick}
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	end)

	Stat:SetScript("OnEnter", function(self)
		if InCombatLockdown() or not IsInGuild() then return end
		
		GuildRoster()
		UpdateGuildMessage()
		BuildGuildTable()
			
		local name, rank, level, zone, note, officernote, connected, status, class, isMobile
		local zonec, classc, levelc
		local online = totalOnline
		local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
		local GuildInfo = GetGuildInfo('player')
		local GuildLevel = GetGuildLevel()
			
		local anchor, panel, xoff, yoff = N.DataTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..N.myname.."'s"..hexb.." Guild")		
		if GuildInfo then
			GameTooltip:AddDoubleLine(string.format(guildInfoString0, GuildInfo), string.format(guildInfoString1, "Guild Level:", GuildLevel),tthead.r,tthead.g,tthead.b,tthead.r,tthead.g,tthead.b)		
		end
		GameTooltip:AddLine' '
		if GuildLevel then
			GameTooltip:AddLine( string.format(guildInfoString2, "Member's Online", online, #guildTable),tthead.r,tthead.g,tthead.b)		
		end
		
		if guildMotD ~= "" then GameTooltip:AddLine(' ') 
			GameTooltip:AddLine(string.format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1) 
		end
		
		local col = RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)
		GameTooltip:AddLine' '
		if GuildLevel and GuildLevel ~= 25 then
			--UpdateGuildXP()
			
			if guildXP[0] then
				local currentXP, nextLevelXP, percentTotal = unpack(guildXP[0])
				
				GameTooltip:AddLine(string.format(col..GUILD_EXPERIENCE_CURRENT, "|r |cFFFFFFFF"..ShortValue(currentXP), ShortValue(nextLevelXP), percentTotal))
			end
		end
		
		local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
		if standingID ~= 8 then -- Not Max Rep
			barMax = barMax - barMin
			barValue = barValue - barMin
			barMin = 0
			GameTooltip:AddLine(string.format("%s:|r |cFFFFFFFF%s/%s (%s%%)",col..COMBAT_FACTION_CHANGE, ShortValue(barValue), ShortValue(barMax), math.ceil((barValue / barMax) * 100)))
		end
		
		if online > 1 then
			GameTooltip:AddLine(' ')
			for i = 1, #guildTable do
				if online <= 1 then
					if online > 1 then GameTooltip:AddLine(format("+ %d More...", online - modules.Guild.maxguild),ttsubh.r,ttsubh.g,ttsubh.b) end
					break
				end

				name, rank, level, zone, note, officernote, connected, status, class, isMobile = unpack(guildTable[i])
				if connected and name ~= nDatamyname then
					if GetRealZoneText() == zone then zonec = activezone else zonec = inactivezone end
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)
					
					if isMobile then zone = "" end
					
					if IsShiftKeyDown() then
						GameTooltip:AddDoubleLine(string.format(nameRankString, name, rank), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
						if note ~= "" then GameTooltip:AddLine(string.format(noteString, note), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
						if officernote ~= "" then GameTooltip:AddLine(string.format(officerNoteString, officernote), ttoff.r, ttoff.g, ttoff.b ,1) end
					else
						GameTooltip:AddDoubleLine(string.format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
					end
				end
			end
		end
		GameTooltip:AddLine' '
		GameTooltip:AddLine("|cffeda55fLeft Click|r to Open Guild Roster")
		GameTooltip:AddLine("|cffeda55fHold Shift & Mouseover|r to See Guild and Officer Note's")
		GameTooltip:AddLine("|cffeda55fRight Click|r to open Options Menu")		
		GameTooltip:Show()
	end)

	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnMouseDown", function(self, btn)
		if btn ~= "LeftButton" then return end
		ToggleGuildFrame()
	end)

	Stat:RegisterEvent("GUILD_ROSTER_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:RegisterEvent("GUILD_ROSTER_UPDATE")
	Stat:RegisterEvent("PLAYER_GUILD_UPDATE")
	Stat:SetScript("OnEvent", Update)
end