local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Threatbar.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

if C['nData'].threatbar == true then

	local aggroColors = {
		[1] = {1, 0, 0},
		[2] = {1, 1, 0},
		[3] = {0, 1, 0},
	}

	local ThreatBar = CreateFrame("StatusBar", "ThreatBar", UIParent)
	ThreatBar:SetPoint("TOPLEFT", PanelCenter, 2, -2)
	ThreatBar:SetPoint("BOTTOMRIGHT", PanelCenter, -2, 2)
	ThreatBar:SetFrameLevel(1)

	ThreatBar.text = N.SetFontString(ThreatBar, C['nMedia'].font, 18)
	ThreatBar.text:SetPoint("CENTER", ThreatBar, 0, 0)
		 

	local function OnEvent(self, event, ...)
		local party = GetNumSubgroupMembers ()
		local raid = GetNumGroupMembers()
		local pet = select(1, HasPetUI())
		if event == "PLAYER_ENTERING_WORLD" then
			self:Hide()
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if party > 0 or raid > 0 or pet == 1 then
				self:Show()
			else
				self:Hide()
			end
		else
			if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
				self:Show()
			else
				self:Hide()
			end
		end
	end

	local function OnUpdate(self, event, unit)
		if UnitAffectingCombat(self.unit) then
			local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
			local threatval = threatpct or 0
			
			self:SetValue(threatval)
			self.text:SetFormattedText("%s ".."%3.1f%%|r", "Threat on current target:", threatval)
			
			if( threatval < 30 ) then
				self.text:SetTextColor(unpack(self.Colors[3]))
			elseif( threatval >= 30 and threatval < 70 ) then
				self.text:SetTextColor(unpack(self.Colors[2]))
			else
				self.text:SetTextColor(unpack(self.Colors[1]))
			end	
					
			if threatval > 0 then
				self:SetAlpha(1)
				PanelCenter:SetAlpha(0)
			else
				self:SetAlpha(0)
				PanelCenter:SetAlpha(1)
			end		
		end
	end

	ThreatBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	ThreatBar:RegisterEvent("PLAYER_REGEN_ENABLED")
	ThreatBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	ThreatBar:SetScript("OnEvent", OnEvent)
	ThreatBar:SetScript("OnUpdate", OnUpdate)
	ThreatBar.unit = "player"
	ThreatBar.tar = ThreatBar.unit.."target"
	ThreatBar.Colors = aggroColors
	ThreatBar:SetAlpha(0)
end