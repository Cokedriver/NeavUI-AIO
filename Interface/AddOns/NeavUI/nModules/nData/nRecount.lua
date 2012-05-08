local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Recount.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

local currentFightDPS

if C['nData'].recount and C['nData'].recount > 0 then 

	local RecountDPS = CreateFrame("Frame")
	RecountDPS:EnableMouse(true)
	RecountDPS:SetFrameStrata("MEDIUM")
	RecountDPS:SetFrameLevel(3)

	local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	N.PP(C['nData'].recount, Text)
	RecountDPS:SetAllPoints(Text)

	function OnEvent(self, event, ...)
		if event == "PLAYER_LOGIN" then
			if IsAddOnLoaded("Recount") then
				RecountDPS:RegisterEvent("PLAYER_REGEN_ENABLED")
				RecountDPS:RegisterEvent("PLAYER_REGEN_DISABLED")
				myname = UnitName("player")
				currentFightDPS = 0
			else
				return
			end
			RecountDPS:UnregisterEvent("PLAYER_LOGIN")
		elseif event == "PLAYER_ENTERING_WORLD" then
			self.updateDPS()
			RecountDPS:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end

	function RecountDPS:RecountHook_UpdateText()
		self:updateDPS()
	end

	function RecountDPS:updateDPS()
		Text:SetText(hexa.."DPS: "..hexb.. RecountDPS.getDPS() .. "|r")
	end

	function RecountDPS:getDPS()
		if not IsAddOnLoaded("Recount") then return "N/A" end
		if C['nData'].recountraiddps == true then
			-- show raid dps
			_, dps = RecountDPS:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			return dps
		else
			return RecountDPS.getValuePerSecond()
		end
	end

	-- quick dps calculation from recount's Data
	function RecountDPS:getValuePerSecond()
		local _, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[myname], Recount.db.profile.CurDataSet)
		return math.floor(10 * dps + 0.5) / 10
	end

	function RecountDPS:getRaidValuePerSecond(tablename)
		local dps, curdps, Data, damage, temp = 0, 0, nil, 0, 0
		for _,Data in pairs(Recount.db2.combatants) do
			if Data.Fights and Data.Fights[tablename] and (Data.type=="Self" or Data.type=="Grouped" or Data.type=="Pet" or Data.type=="Ungrouped") then
				temp, curdps = Recount:MergedPetDamageDPS(Data,tablename)
				if Data.type ~= "Pet" or (not Recount.db.profile.MergePets and Data.Owner and (Recount.db2.combatants[Data.Owner].type=="Self" or Recount.db2.combatants[Data.Owner].type=="Grouped" or Recount.db2.combatants[Data.Owner].type=="Ungrouped")) or (not Recount.db.profile.MergePets and Data.Name and Data.GUID and self:matchUnitGUID(Data.Name, Data.GUID)) then
					dps = dps + 10 * curdps
					damage = damage + temp
				end
			end
		end
		return math.floor(damage + 0.5) / 10, math.floor(dps + 0.5)/10
	end

	-- tracked events
	RecountDPS:RegisterEvent("PLAYER_LOGIN")
	RecountDPS:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- scripts
	RecountDPS:SetScript("OnEnter", function(self)
		if InCombatLockdown() then return end

		local anchor, panel, xoff, yoff = N.DataTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..N.myname.."'s"..hexb.." Damage")
		GameTooltip:AddLine' '		
		if IsAddOnLoaded("Recount") then
			local damage, dps = Recount:MergedPetDamageDPS(Recount.db2.combatants[myname], Recount.db.profile.CurDataSet)
			local raid_damage, raid_dps = RecountDPS:getRaidValuePerSecond(Recount.db.profile.CurDataSet)
			-- format the number
			dps = math.floor(10 * dps + 0.5) / 10
			GameTooltip:AddLine("Recount")
			GameTooltip:AddDoubleLine("Personal Damage:", damage, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Personal DPS:", dps, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("Raid Damage:", raid_damage, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddDoubleLine("Raid DPS:", raid_dps, 1, 1, 1, 0.8, 0.8, 0.8)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cffeda55fLeft Click|r to toggle Recount")
			GameTooltip:AddLine("|cffeda55fRight Click|r to reset Data")
			GameTooltip:AddLine("|cffeda55fShift + Right Click|r to open config")
		else
			GameTooltip:AddLine("Recount is not loaded.", 255, 0, 0)
			GameTooltip:AddLine("Enable Recount and reload your UI.")
		end
		GameTooltip:Show()
	end)
	RecountDPS:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			if not IsShiftKeyDown() then
				Recount:ShowReset()
			else
				Recount:ShowConfig()
			end
		elseif button == "LeftButton" then
			if Recount.MainWindow:IsShown() then
				Recount.MainWindow:Hide()
			else
				Recount.MainWindow:Show()
				Recount:RefreshMainWindow()
			end
		end
	end)
	RecountDPS:SetScript("OnEvent", OnEvent)
	RecountDPS:SetScript("OnLeave", function() GameTooltip:Hide() end)
	RecountDPS:SetScript("OnUpdate", function(self, t)
		local int = -1
		int = int - t
		if int < 0 then
			self.updateDPS()
			int = 1
		end
	end)
end