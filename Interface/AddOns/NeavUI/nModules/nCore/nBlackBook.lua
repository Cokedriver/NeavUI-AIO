local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

local L = setmetatable({}, { __index = function(t,k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end })

--[[

	All Credit for BlackBook.lua goes to Xinhuan.
	Postal = http://www.wowinterface.com/downloads/info11187-Postal.html.
	Edited by Cokedriver.
	
]]

 -- Credit for BlackBook goes to Xinhuan and grennon from WoWAce.com
if C['nCore'].BlackBook.enable == true then
	local NeavUIConfig = LibStub("AceAddon-3.0"):GetAddon("NeavUIConfig")
	local Mail_BlackBook = NeavUIConfig:NewModule("BlackBook", "AceEvent-3.0", "AceHook-3.0")
	Mail_BlackBook.description = "Adds a contact list next to the To: field."
	Mail_BlackBook.description2 = [[|cFFFFCC00*|r This module will list your contacts, friends, guild mates, alts and track the last 10 people you mailed.
	|cFFFFCC00*|r It will also autocomplete all names in your BlackBook.]] 

	-- Use a common frame and setup some common functions for the Mail dropdown menus
	local Mail_DropDownMenu = CreateFrame("Frame", "Mail_DropDownMenu")
	Mail_DropDownMenu.displayMode = "MENU"
	Mail_DropDownMenu.info = {}
	Mail_DropDownMenu.levelAdjust = 0
	Mail_DropDownMenu.UncheckHack = function(dropdownbutton)
		_G[dropdownbutton:GetName().."Check"]:Hide()
		if TOC >= 40000 then
			_G[dropdownbutton:GetName().."UnCheck"]:Hide()
		end
	end
	Mail_DropDownMenu.HideMenu = function()
		if UIDROPDOWNMENU_OPEN_MENU == Mail_DropDownMenu then
			CloseDropDownMenus()
		end
	end

	local Mail_BlackBookButton
	local numFriendsOnList = 0
	local sorttable = {}
	local ignoresortlocale = {
		["koKR"] = true,
		["zhCN"] = true,
		["zhTW"] = true,
	}
	local enableAltsMenu = true
	local Mail_BlackBook_Autocomplete_Flags = {
		include = AUTOCOMPLETE_FLAG_ALL,
		exclude = AUTOCOMPLETE_FLAG_NONE,
	}

	function Mail_BlackBook:OnEnable()
		if not Mail_BlackBookButton then
			-- Create the Menu Button
			Mail_BlackBookButton = CreateFrame("Button", "Mail_BlackBookButton", SendMailFrame)
			Mail_BlackBookButton:SetWidth(25)
			Mail_BlackBookButton:SetHeight(25)
			Mail_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", -2, 0)
			Mail_BlackBookButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			Mail_BlackBookButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
			Mail_BlackBookButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
			Mail_BlackBookButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			Mail_BlackBookButton:SetScript("OnClick", function(self, button, down)
				if Mail_DropDownMenu.initialize ~= Mail_BlackBook.BlackBookMenu then
					CloseDropDownMenus()
					Mail_DropDownMenu.initialize = Mail_BlackBook.BlackBookMenu
				end
				ToggleDropDownMenu(1, nil, Mail_DropDownMenu, self:GetName(), 0, 0)
			end)
			Mail_BlackBookButton:SetScript("OnHide", Mail_DropDownMenu.HideMenu)
		end

		local db = C['nCore'].BlackBook

		SendMailNameEditBox:SetHistoryLines(15)
		self:RawHook("SendMailFrame_Reset", true)
		self:RawHook("MailFrameTab_OnClick", true)
		if db.UseAutoComplete then
			self:RawHookScript(SendMailNameEditBox, "OnChar")
		end
		self:HookScript(SendMailNameEditBox, "OnEditFocusGained")
		self:RawHook("AutoComplete_Update", true)
		self:RegisterEvent("MAIL_SHOW")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "AddAlt")

		local exclude = bit.bor(db.AutoCompleteFriends and AUTOCOMPLETE_FLAG_NONE or AUTOCOMPLETE_FLAG_FRIEND,
			db.AutoCompleteGuild and AUTOCOMPLETE_FLAG_NONE or AUTOCOMPLETE_FLAG_IN_GUILD)
		Mail_BlackBook_Autocomplete_Flags.include = bit.bxor(
			db.ExcludeRandoms and (bit.bor(AUTOCOMPLETE_FLAG_FRIEND, AUTOCOMPLETE_FLAG_IN_GUILD)) or AUTOCOMPLETE_FLAG_ALL, exclude)
		SendMailNameEditBox.autoCompleteParams = Mail_BlackBook_Autocomplete_Flags

		-- Delete Real ID database. Patch 4.0.1 onwards no longer allows addons to obtain Real ID information.
		NeavUIConfig.db.global.BlackBook.realID = nil
		db.AutoCompleteRealIDFriends = nil

		-- Delete old recent data without faction and realm data
		for i = #C['nCore'].BlackBook.recent, 1, -1 do
			local p, r, f = strsplit("|", C['nCore'].BlackBook.recent[i])
			if (not r) or (not f) then
				tremove(C['nCore'].BlackBook.recent, i)
			end
		end

		-- For enabling after a disable
		Mail_BlackBookButton:Show()
	end

	function Mail_BlackBook:OnDisable()
		-- Disabling modules unregisters all events/hook automatically
		SendMailNameEditBox:SetHistoryLines(1)
		Mail_BlackBookButton:Hide()
		SendMailNameEditBox.autoCompleteParams = AUTOCOMPLETE_LIST.MAIL
	end

	function Mail_BlackBook:MAIL_SHOW()
		self:RegisterEvent("MAIL_CLOSED", "Reset")
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
		if self.AddAlt then self:AddAlt() end
	end

	function Mail_BlackBook:Reset(event)
		self:UnregisterEvent("MAIL_CLOSED")
		self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	end

	-- We do this once on MAIL_SHOW because UnitFactionGroup() is only valid after
	-- PLAYER_ENTERING_WORLD and because Mail might be LoD due to AddOnLoader
	-- and PLAYER_ENTERING_WORLD won't fire in that scenerio.
	function Mail_BlackBook:AddAlt()
		local realm = GetRealmName()
		local faction = UnitFactionGroup("player")
		local player = UnitName("player")
		local level = UnitLevel("player")
		local _, class = UnitClass("player")
		if not realm or not faction or not player or not level or not class then return end
		local namestring = ("%s|%s|%s|%s|%s"):format(player, realm, faction, level, class)
		local flag = true
		local db = NeavUIConfig.db.global.BlackBook.alts
		enableAltsMenu = false
		for i = #db, 1, -1 do
			local p, r, f, l, c = strsplit("|", db[i])
			if p == player and r == realm and f == faction then
				tremove(db, i)
			end
			if p ~= player and r == realm and f == faction then
				enableAltsMenu = true
			end
		end
		if flag then
			tinsert(db, namestring)
			table.sort(db)
		end
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.AddAlt = nil -- Kill ourselves so we only run it once
	end

	function Mail_BlackBook.DeleteAlt(dropdownbutton, arg1, arg2, checked)
		local realm = GetRealmName()
		local faction = UnitFactionGroup("player")
		local player = UnitName("player")
		local db = NeavUIConfig.db.global.BlackBook.alts
		enableAltsMenu = false
		for i = #db, 1, -1 do
			if arg1 == db[i] then
				tremove(db, i)
			else
				local p, r, f = strsplit("|", db[i])
				if r == realm and f == faction and p ~= player then
					enableAltsMenu = true
				end
			end
		end
		CloseDropDownMenus()
	end

	-- Only called on a mail that is sent successfully
	function Mail_BlackBook:SendMailFrame_Reset()
		local name = strtrim(SendMailNameEditBox:GetText())
		if name == "" then return self.hooks["SendMailFrame_Reset"]() end
		SendMailNameEditBox:AddHistoryLine(name)

		local realm = GetRealmName()
		local faction = UnitFactionGroup("player")
		if not realm or not faction then return self.hooks["SendMailFrame_Reset"]() end

		local namestring = ("%s|%s|%s"):format(name, realm, faction)
		local db = C['nCore'].BlackBook.recent
		for k = 1, #db do
			if namestring == db[k] then tremove(db, k) break end
		end
		tinsert(db, 1, namestring)
		for k = #db, 21, -1 do
			tremove(db, k)
		end
		local a, b, c = self.hooks["SendMailFrame_Reset"]()
		if C['nCore'].BlackBook.AutoFill then
			SendMailNameEditBox:SetText(name)
			SendMailNameEditBox:HighlightText()
		end
		return a, b, c
	end

	function Mail_BlackBook.ClearRecent(dropdownbutton, arg1, arg2, checked)
		wipe(C['nCore'].BlackBook.recent)
		CloseDropDownMenus()
	end

	function Mail_BlackBook:MailFrameTab_OnClick(button, tab)
		self.hooks["MailFrameTab_OnClick"](button, tab)
		if C['nCore'].BlackBook.AutoFill and tab == 2 then
			local realm = GetRealmName()
			local faction = UnitFactionGroup("player")
			local player = UnitName("player")
			
			-- Find the first eligible recently mailed
			for i = 1, #C['nCore'].BlackBook.recent do
				local p, r, f = strsplit("|", C['nCore'].BlackBook.recent[i])
				if r == realm and f == faction and p ~= player then
					if p and SendMailNameEditBox:GetText() == "" then
						SendMailNameEditBox:SetText(p)
						SendMailNameEditBox:HighlightText()
						break
					end
				end
			end
		end
	end

	function Mail_BlackBook:OnEditFocusGained(editbox, ...)
		-- Most other addons aren't hooking properly and do not pass in editbox at all.
		SendMailNameEditBox:HighlightText()
	end

	function Mail_BlackBook:AutoComplete_Update(editBox, editBoxText, utf8Position, ...)
		if editBox ~= SendMailNameEditBox or not C['nCore'].BlackBook.DisableBlizzardAutoComplete then
			self.hooks["AutoComplete_Update"](editBox, editBoxText, utf8Position, ...)
		end
	end

	-- OnChar fires before OnTextChanged
	-- OnChar does not fire for Backspace, Delete keys that shorten the text
	-- Hook player name autocomplete to look in our dbs first
	function Mail_BlackBook:OnChar(editbox, ...)
		if editbox:GetUTF8CursorPosition() ~= strlenutf8(editbox:GetText()) then return end

		local db = C['nCore'].BlackBook
		local text = strupper(editbox:GetText())
		local textlen = strlen(text)
		local realm = GetRealmName()
		local faction = UnitFactionGroup("player")
		local player = UnitName("player")
		local newname

		-- Check alt list
		if db.AutoCompleteAlts then
			local db = NeavUIConfig.db.global.BlackBook.alts
			for i = 1, #db do
				local p, r, f = strsplit("|", db[i])
				if r == realm and f == faction and p ~= player then
					if strfind(strupper(p), text, 1, 1) == 1 then
						newname = p
						break
					end
				end
			end
		end

		-- Check recent list
		if not newname and db.AutoCompleteRecent then
			local db2 = db.recent
			for j = 1, #db2 do
				local p, r, f = strsplit("|", db2[j])
				if r == realm and f == faction and p ~= player then
					if strfind(strupper(p), text, 1, 1) == 1 then
						newname = p
						break
					end
				end
			end
		end

		-- Check contacts list
		if not newname and db.AutoCompleteContacts then
			local db2 = db.contacts
			for j = 1, #db2 do
				local name = db2[j]
				if strfind(strupper(name), text, 1, 1) == 1 then
					newname = name
					break
				end
			end
		end

		-- Check RealID friends that are online
		if not newname and db.AutoCompleteFriends then
			local numBNetTotal, numBNetOnline = BNGetNumFriends()
			for i = 1, numBNetOnline do
				local presenceID, givenName, surname, toonName, toonID, client = BNGetFriendInfo(i)
				if (toonName and client == BNET_CLIENT_WOW and CanCooperateWithToon(toonID)) then
					if strfind(strupper(toonName), text, 1, 1) == 1 then
						newname = toonName
						break
					end
				end
			end
		end

		-- Call the original Blizzard function to autocomplete and for its popup
		self.hooks[SendMailNameEditBox].OnChar(editbox, ...)

		-- Set our match if we found one (overriding Blizzard's match if there's one)
		if newname then
			editbox:SetText(newname)
			editbox:HighlightText(textlen, -1)
			editbox:SetCursorPosition(textlen)
		end
	end

	function Mail_BlackBook.SetSendMailName(dropdownbutton, arg1, arg2, checked)
		SendMailNameEditBox:SetText(arg1)
		if SendMailNameEditBox:HasFocus() then SendMailSubjectEditBox:SetFocus() end
		CloseDropDownMenus()
	end

	function Mail_BlackBook.AddContact(dropdownbutton, arg1, arg2, checked)
		local name = strtrim(SendMailNameEditBox:GetText())
		if name == "" then return end
		local db = C['nCore'].BlackBook.contacts
		for k = 1, #db do
			if name == db[k] then return end
		end
		tinsert(db, name)
		table.sort(db)
	end

	function Mail_BlackBook.RemoveContact(dropdownbutton, arg1, arg2, checked)
		local name = strtrim(SendMailNameEditBox:GetText())
		if name == "" then return end
		local db = C['nCore'].BlackBook.contacts
		for k = 1, #db do
			if name == db[k] then tremove(db, k) return end
		end
	end

	function Mail_BlackBook:SortAndCountNumFriends()
		wipe(sorttable)
		local numFriends = GetNumFriends()
		for i = 1, numFriends do
			sorttable[i] = GetFriendInfo(i)
		end

		-- Battle.net friends
		if BNGetNumFriends then -- For pre 3.3.5 backwards compat
			local numBNetTotal, numBNetOnline = BNGetNumFriends()
			for i= 1, numBNetOnline do
				local presenceID, givenName, surname, toonName, toonID, client = BNGetFriendInfo(i)
				--local hasFocus, toonName, client = BNGetToonInfo(toonID)
				if (toonName and client == BNET_CLIENT_WOW and CanCooperateWithToon(toonID)) then
					-- Check if already on friends list
					local alreadyOnList = false
					for j = 1, numFriends do
						if sorttable[j] == toonName then
							alreadyOnList = true
							break
						end
					end			
					if not alreadyOnList then
						numFriends = numFriends + 1
						sorttable[numFriends] = toonName
					end
				end
			end
		end

		-- Sort the list
		if numFriends > 0 and not ignoresortlocale[GetLocale()] then table.sort(sorttable) end

		-- Store upvalue
		numFriendsOnList = numFriends
		return numFriends
	end

	function Mail_BlackBook.BlackBookMenu(self, level)
		if not level then return end
		local info = self.info
		wipe(info)
		if level == 1 then
			info.isTitle = 1
			info.text = "Contacts"
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)

			info.disabled = nil
			info.isTitle = nil

			local db = C['nCore'].BlackBook.contacts
			for i = 1, #db do
				info.text = db[i]
				info.func = Mail_BlackBook.SetSendMailName
				info.arg1 = db[i]
				UIDropDownMenu_AddButton(info, level)
			end

			info.arg1 = nil
			if #db > 0 then
				info.disabled = 1
				info.text = nil
				info.func = nil
				UIDropDownMenu_AddButton(info, level)
				info.disabled = nil
			end

			info.text = "Add Contact"
			info.func = Mail_BlackBook.AddContact
			UIDropDownMenu_AddButton(info, level)

			info.text = "Remove Contact"
			info.func = Mail_BlackBook.RemoveContact
			UIDropDownMenu_AddButton(info, level)

			info.disabled = 1
			info.text = nil
			info.func = nil
			UIDropDownMenu_AddButton(info, level)

			info.hasArrow = 1
			info.keepShownOnClick = 1
			info.func = self.UncheckHack

			info.disabled = #C['nCore'].BlackBook.recent == 0
			info.text = "Recently Mailed"
			info.value = "recent"
			UIDropDownMenu_AddButton(info, level)

			info.disabled = not enableAltsMenu
			info.text = "Alts"
			info.value = "alt"
			UIDropDownMenu_AddButton(info, level)

			info.disabled = Mail_BlackBook:SortAndCountNumFriends() == 0
			info.text = "Friends"
			info.value = "friend"
			UIDropDownMenu_AddButton(info, level)

			info.disabled = not IsInGuild()
			info.text = "Guild"
			info.value = "guild"
			UIDropDownMenu_AddButton(info, level)

			wipe(info)
			info.disabled = 1
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil

			info.text = CLOSE
			info.func = self.HideMenu
			UIDropDownMenu_AddButton(info, level)

		elseif level == 2 then
			info.notCheckable = 1
			if UIDROPDOWNMENU_MENU_VALUE == "recent" then
				local realm = GetRealmName()
				local faction = UnitFactionGroup("player")
				local player = UnitName("player")
				local db = C['nCore'].BlackBook.recent
				if #db == 0 then return end
				for i = 1, #db do
					local p, r, f = strsplit("|", db[i])
					if r == realm and f == faction and p ~= player then
						info.text = p
						info.func = Mail_BlackBook.SetSendMailName
						info.arg1 = p
						UIDropDownMenu_AddButton(info, level)
					end
				end

				info.disabled = 1
				info.text = nil
				info.func = nil
				info.arg1 = nil
				UIDropDownMenu_AddButton(info, level)
				info.disabled = nil

				info.text = "Clear list"
				info.func = Mail_BlackBook.ClearRecent
				info.arg1 = nil
				UIDropDownMenu_AddButton(info, level)

			elseif UIDROPDOWNMENU_MENU_VALUE == "alt" then
				if not enableAltsMenu then return end
				local db = NeavUIConfig.db.global.BlackBook.alts
				local realm = GetRealmName()
				local faction = UnitFactionGroup("player")
				local player = UnitName("player")
				info.notCheckable = 1
				for i = 1, #db do
					local p, r, f, l, c = strsplit("|", db[i])
					if r == realm and f == faction and p ~= player then
						if l and c then
							local clr = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[c] or RAID_CLASS_COLORS[c]
							info.text = format("%s |cff%.2x%.2x%.2x(%d %s)|r", p, clr.r*255, clr.g*255, clr.b*255, l, LOCALIZED_CLASS_NAMES_MALE[c])
						else
							info.text = p
						end
						info.func = Mail_BlackBook.SetSendMailName
						info.arg1 = p
						UIDropDownMenu_AddButton(info, level)
					end
				end

				info.disabled = 1
				info.text = nil
				info.func = nil
				info.arg1 = nil
				UIDropDownMenu_AddButton(info, level)
				info.disabled = nil

				info.text = "Delete"
				info.hasArrow = 1
				info.keepShownOnClick = 1
				info.func = self.UncheckHack
				info.value = "deletealt"
				UIDropDownMenu_AddButton(info, level)

			elseif UIDROPDOWNMENU_MENU_VALUE == "friend" then
				-- Friends list
				local numFriends = Mail_BlackBook:SortAndCountNumFriends()

				-- 25 or less, don't need multi level menus
				if numFriends > 0 and numFriends <= 25 then
					for i = 1, numFriends do
						local name = sorttable[i]
						info.text = name
						info.func = Mail_BlackBook.SetSendMailName
						info.arg1 = name
						UIDropDownMenu_AddButton(info, level)
					end
				elseif numFriends > 25 then
					-- More than 25 people, split the list into multiple sublists of 25
					info.hasArrow = 1
					info.keepShownOnClick = 1
					info.func = self.UncheckHack
					for i = 1, math.ceil(numFriends/25) do
						info.text  = L["Part %d"]:format(i)
						info.value = "fpart"..i
						UIDropDownMenu_AddButton(info, level)
					end
				end

			elseif UIDROPDOWNMENU_MENU_VALUE == "guild" then
				if not IsInGuild() then return end
				local numFriends = GetNumGuildMembers(true)
				for i = 1, numFriends do
					local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i)
					local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classFileName] or RAID_CLASS_COLORS[classFileName]
					sorttable[i] = format("%s |cffffd200(%s)|r |cff%.2x%.2x%.2x(%d %s)|r", name, rank, c.r*255, c.g*255, c.b*255, level, class)
				end
				for i = #sorttable, numFriends+1, -1 do
					sorttable[i] = nil
				end
				if not ignoresortlocale[GetLocale()] then table.sort(sorttable) end
				if numFriends > 0 and numFriends <= 25 then
					for i = 1, numFriends do
						info.text = sorttable[i]
						info.func = Mail_BlackBook.SetSendMailName
						info.arg1 = strmatch(sorttable[i], "(.*) |cffffd200")
						UIDropDownMenu_AddButton(info, level)
					end
				elseif numFriends > 25 then
					-- More than 25 people, split the list into multiple sublists of 25
					info.hasArrow = 1
					info.keepShownOnClick = 1
					info.func = self.UncheckHack
					for i = 1, math.ceil(numFriends/25) do
						info.text  = L["Part %d"]:format(i)
						info.value = "gpart"..i
						UIDropDownMenu_AddButton(info, level)
					end
				end
			end

		elseif level >= 3 then
			info.notCheckable = 1
			if UIDROPDOWNMENU_MENU_VALUE == "deletealt" then
				local db = NeavUIConfig.db.global.BlackBook.alts
				local realm = GetRealmName()
				local faction = UnitFactionGroup("player")
				local player = UnitName("player")
				for i = 1, #db do
					local p, r, f, l, c = strsplit("|", db[i])
					if r == realm and f == faction and p ~= player then
						if l and c then
							local clr = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[c] or RAID_CLASS_COLORS[c]
							info.text = format("%s |cff%.2x%.2x%.2x(%d %s)|r", p, clr.r*255, clr.g*255, clr.b*255, l, LOCALIZED_CLASS_NAMES_MALE[c])
						else
							info.text = p
						end
						info.func = Mail_BlackBook.DeleteAlt
						info.arg1 = db[i]
						UIDropDownMenu_AddButton(info, level)
					end
				end

			elseif strfind(UIDROPDOWNMENU_MENU_VALUE, "fpart") then
				local startIndex = tonumber(strmatch(UIDROPDOWNMENU_MENU_VALUE, "fpart(%d+)")) * 25 - 24
				local endIndex = math.min(startIndex+24, numFriendsOnList)
				for i = startIndex, endIndex do
					local name = sorttable[i]
					info.text = name
					info.func = Mail_BlackBook.SetSendMailName
					info.arg1 = name
					UIDropDownMenu_AddButton(info, level)
				end

			elseif strfind(UIDROPDOWNMENU_MENU_VALUE, "gpart") then
				local startIndex = tonumber(strmatch(UIDROPDOWNMENU_MENU_VALUE, "gpart(%d+)")) * 25 - 24
				local endIndex = math.min(startIndex+24, (GetNumGuildMembers(true)))
				for i = startIndex, endIndex do
					local name = sorttable[i]
					info.text = sorttable[i]
					info.func = Mail_BlackBook.SetSendMailName
					info.arg1 = strmatch(sorttable[i], "(.*) |cffffd200")
					UIDropDownMenu_AddButton(info, level)
				end
			end

		end
	end

	function Mail_BlackBook.SaveFriendGuildOption(dropdownbutton, arg1, arg2, checked)
		Mail.SaveOption(dropdownbutton, arg1, arg2, checked)
		local db = C['nCore'].BlackBook
		local exclude = bit.bor(db.AutoCompleteFriends and AUTOCOMPLETE_FLAG_NONE or AUTOCOMPLETE_FLAG_FRIEND,
			db.AutoCompleteGuild and AUTOCOMPLETE_FLAG_NONE or AUTOCOMPLETE_FLAG_IN_GUILD)
		Mail_BlackBook_Autocomplete_Flags.include = bit.bxor(
			db.ExcludeRandoms and (bit.bor(AUTOCOMPLETE_FLAG_FRIEND, AUTOCOMPLETE_FLAG_IN_GUILD)) or AUTOCOMPLETE_FLAG_ALL, exclude)
	end

	function Mail_BlackBook.SetAutoComplete(dropdownbutton, arg1, arg2, checked)
		local self = Mail_BlackBook
		C['nCore'].BlackBook.UseAutoComplete = not checked
		if checked then
			if self:IsHooked(SendMailNameEditBox, "OnChar") then
				self:Unhook(SendMailNameEditBox, "OnChar")
			end
		else
			if not self:IsHooked(SendMailNameEditBox, "OnChar") then
				self:RawHookScript(SendMailNameEditBox, "OnChar")
			end
		end
	end

	function Mail_BlackBook.ModuleMenu(self, level)
		if not level then return end
		local info = self.info
		wipe(info)
		info.isNotRadio = 1
		if level == 1 + self.levelAdjust then
			info.keepShownOnClick = 1
			info.text = "Autofill last person mailed"
			info.func = Mail.SaveOption
			info.arg1 = "BlackBook"
			info.arg2 = "AutoFill"
			info.checked = C['nCore'].BlackBook.AutoFill
			UIDropDownMenu_AddButton(info, level)

			info.hasArrow = 1
			info.keepShownOnClick = 1
			info.func = self.UncheckHack
			info.checked = nil
			info.arg1 = nil
			info.arg2 = nil
			info.text = "Name auto-completion options"
			info.value = "AutoComplete"
			UIDropDownMenu_AddButton(info, level)
			local listFrame = _G["DropDownList"..level]
			self.UncheckHack(_G[listFrame:GetName().."Button"..listFrame.numButtons])

		elseif level == 2 + self.levelAdjust then
			local db = C['nCore'].BlackBook
			info.arg1 = "BlackBook"

			if UIDROPDOWNMENU_MENU_VALUE == "AutoComplete" then
				info.text = "Use Mail's auto-complete"
				info.arg2 = "UseAutoComplete"
				info.checked = db.UseAutoComplete
				info.func = Mail_BlackBook.SetAutoComplete
				UIDropDownMenu_AddButton(info, level)

				info.func = Mail.SaveOption
				info.disabled = not db.UseAutoComplete
				info.keepShownOnClick = 1

				info.text = "Alts"
				info.arg2 = "AutoCompleteAlts"
				info.checked = db.AutoCompleteAlts
				UIDropDownMenu_AddButton(info, level)

				info.text = "Recently Mailed"
				info.arg2 = "AutoCompleteRecent"
				info.checked = db.AutoCompleteRecent
				UIDropDownMenu_AddButton(info, level)

				info.text = "Contacts"
				info.arg2 = "AutoCompleteContacts"
				info.checked = db.AutoCompleteContacts
				UIDropDownMenu_AddButton(info, level)

				info.disabled = nil

				info.text = "Friends"
				info.arg2 = "AutoCompleteFriends"
				info.checked = db.AutoCompleteFriends
				info.func = Mail_BlackBook.SaveFriendGuildOption
				UIDropDownMenu_AddButton(info, level)

				info.text = "Guild"
				info.arg2 = "AutoCompleteGuild"
				info.checked = db.AutoCompleteGuild
				UIDropDownMenu_AddButton(info, level)

				info.text = "Exclude randoms you interacted with"
				info.arg2 = "ExcludeRandoms"
				info.checked = db.ExcludeRandoms
				UIDropDownMenu_AddButton(info, level)

				info.text = "Disable Blizzard's auto-completion popup menu"
				info.arg2 = "DisableBlizzardAutoComplete"
				info.checked = db.DisableBlizzardAutoComplete
				info.func = Mail.SaveOption
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end

local NeavUIConfig = LibStub("AceAddon-3.0"):GetAddon("NeavUIConfig")
local Mail_Wire = NeavUIConfig:NewModule("Wire", "AceHook-3.0")
Mail_Wire.description = "Set subject field to value of coins sent if subject is blank."

local g, s, c
g = "^%["..GOLD_AMOUNT.." "..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
s = "^%["..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
c = "^%["..COPPER_AMOUNT.."%]$"
if GetLocale() == "ruRU" then
	--Because ruRU has these escaped strings which can't be in mail subjects.
	--COPPER_AMOUNT = "%d |4?????? ??????:?????? ??????:?????? ?????;"; -- Lowest value coin denomination
	--SILVER_AMOUNT = "%d |4??????????:??????????:??????????;"; -- Mid value coin denomination
	--GOLD_AMOUNT = "%d |4???????:???????:???????;"; -- Highest value coin denomination
	g = "^%[%d+? %d+? %d+?%]$"
	s = "^%[%d+? %d+?%]$"
	c = "^%[%d+?%]$"
end
g = gsub(g, "%%d", "%%d+")
s = gsub(s, "%%d", "%%d+")
c = gsub(c, "%%d", "%%d+")

function Mail_Wire:OnEnable()
	-- Secure hook so that it calls the original function
	self:SecureHook(SendMailMoney, "onValueChangedFunc")
end

-- Disabling modules unregisters all events/hook automatically
--function Postal_Wire:OnDisable()
--end

function Mail_Wire:onValueChangedFunc()
	local subject = SendMailSubjectEditBox:GetText()
	if subject == "" or subject:find(g) or subject:find(s) or subject:find(c) then
		local money = MoneyInputFrame_GetCopper(SendMailMoney)
		if money and money > 0 then
			local gold = floor(money / 10000)
			local silver = floor((money - gold * 10000) / 100)
			local copper = mod(money, 100)
			if gold > 0 then
				SendMailSubjectEditBox:SetText(format("["..GOLD_AMOUNT.." "..SILVER_AMOUNT.." "..COPPER_AMOUNT.."]", gold, silver, copper))
			elseif silver > 0 then
				SendMailSubjectEditBox:SetText(format("["..SILVER_AMOUNT.." "..COPPER_AMOUNT.."]", silver, copper))
			else
				SendMailSubjectEditBox:SetText(format("["..COPPER_AMOUNT.."]", copper))
			end
		else
			SendMailSubjectEditBox:SetText("")
		end
	end
end