local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Stat2.lua goes to Elv.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

if C['nData'].stat2 and C['nData'].stat2 > 0 then

	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)

	local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	N.PP(C['nData'].stat2, Text)

	local _G = getfenv(0)
	local format = string.format
	local chanceString = "%.2f%%"
	local armorString = hexa..ARMOR..hexb..": "
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local baseArmor, effectiveArmor, armor, posBuff, negBuff
	local displayNumberString = string.join("", "%s", "%d|r")
	local displayFloatString = string.join("", "%s", "%.2f%%|r")
	local level = UnitLevel("player")


	local function CalculateMitigation(level, effective)
		local mitigation
		
		if not effective then
			_, effective, _, _, _ = UnitArmor("player")
		end
		
		if level < 60 then
			mitigation = (effective/(effective + 400 + (85 * level)));
		else
			mitigation = (effective/(effective + (467.5 * level - 22167.5)));
		end
		if mitigation > .75 then
			mitigation = .75
		end
		return mitigation
	end

	local function AddTooltipHeader(description)
		GameTooltip:AddLine(description)
		GameTooltip:AddLine(' ')
	end

	local function ShowTooltip(self)
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = N.DataTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..N.myname.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '	
		
		if N.Role == "Tank" then
			AddTooltipHeader("Mitigation By Level: ")
			local lv = level +3
			for i = 1, 4 do
				GameTooltip:AddDoubleLine(lv,format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
				lv = lv - 1
			end
			lv = UnitLevel("target")
			if lv and lv > 0 and (lv > level + 3 or lv < level) then
				GameTooltip:AddDoubleLine(lv, format(chanceString, CalculateMitigation(lv, effectiveArmor) * 100),1,1,1)
			end	
		elseif N.Role == "Caster" or N.Role == "Melee" then
			AddTooltipHeader(MAGIC_RESISTANCES_COLON)
			
			local baseResistance, effectiveResistance, posResitance, negResistance
			for i = 2, 6 do
				baseResistance, effectiveResistance, posResitance, negResistance = UnitResistance("player", i)
				GameTooltip:AddDoubleLine(_G["DAMAGE_SCHOOL"..(i+1)], format(chanceString, (effectiveResistance / (effectiveResistance + (500 + level + 2.5))) * 100),1,1,1)
			end
			
			local spellpen = GetSpellPenetration()
			if (N.myclass == "SHAMAN" or N.Role == "Caster") and spellpen > 0 then
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(ITEM_MOD_SPELL_PENETRATION_SHORT, spellpen,1,1,1)
			end
		end
		GameTooltip:Show()
	end

	local function UpdateTank(self)
		baseArmor, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
		
		Text:SetFormattedText(displayNumberString, armorString, effectiveArmor)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		local spellcrit = GetSpellCritChance(1)

		Text:SetFormattedText(displayFloatString, hexa.."Crit: "..hexb, spellcrit)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local meleecrit = GetCritChance()
		local rangedcrit = GetRangedCritChance()
		local critChance
			
		if N.myclass == "HUNTER" then    
			critChance = rangedcrit
		else
			critChance = meleecrit
		end
		
		Text:SetFormattedText(displayFloatString, hexa.."Crit: "..hexb, critChance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	-- initial delay for update (let the ui load)
	local int = 5	
	local function Update(self, t)
		int = int - t
		if int > 0 then return end
		
		if N.Role == "Tank" then
			UpdateTank(self)
		elseif N.Role == "Caster" then
			UpdateCaster(self)
		elseif N.Role == "Melee" then
			UpdateMelee(self)		
		end
		int = 2
	end

	Stat:SetScript("OnEnter", function() ShowTooltip(Stat) end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end