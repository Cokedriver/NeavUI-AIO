local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for Stat1.lua goes to Elv.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

if C['nData'].stat1 and C['nData'].stat1 > 0 then

	local Stat = CreateFrame("Frame")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:EnableMouse(true)

	local Text  = DataPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	N.PP(C['nData'].stat1, Text)

	local format = string.format
	local targetlv, playerlv = UnitLevel("target"), UnitLevel("player")
	local basemisschance, leveldifference, dodge, parry, block
	local chanceString = "%.2f%%"
	local modifierString = string.join("", "%d (+", chanceString, ")")
	local manaRegenString = "%d / %d"
	local displayNumberString = string.join("", "%s", "%d|r")
	local displayFloatString = string.join("", "%s", "%.2f%%|r")
	local spellpwr, avoidance, pwr
	local haste, hasteBonus
	local level = UnitLevel("player")

	local function ShowTooltip(self)
		if InCombatLockdown() then return end
	
		local anchor, panel, xoff, yoff = N.DataTooltipAnchor(Text)
		GameTooltip:SetOwner(panel, anchor, xoff, yoff)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(hexa..N.myname.."'s"..hexb.." Statistics")
		GameTooltip:AddLine' '		
		
		if N.Role == "Tank" then
			if targetlv > 1 then
				GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "lvl", " ", targetlv, ")"))
			elseif targetlv == -1 then
				GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "Boss", ")"))
			else
				GameTooltip:AddDoubleLine("Avoidance Breakdown", string.join("", " (", "lvl", " ", playerlv, ")"))
			end
			GameTooltip:AddLine' '
			GameTooltip:AddDoubleLine(DODGE_CHANCE, format(chanceString, dodge),1,1,1)
			GameTooltip:AddDoubleLine(PARRY_CHANCE, format(chanceString, parry),1,1,1)
			GameTooltip:AddDoubleLine(BLOCK_CHANCE, format(chanceString, block),1,1,1)
			GameTooltip:AddDoubleLine(MISS_CHANCE, format(chanceString, basemisschance),1,1,1)
		elseif N.Role == "Caster" then
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, GetCombatRating(CR_HIT_SPELL), GetCombatRatingBonus(CR_HIT_SPELL)), 1, 1, 1)
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, GetCombatRating(CR_HASTE_SPELL), GetCombatRatingBonus(CR_HASTE_SPELL)), 1, 1, 1)
			local base, combat = GetManaRegen()
			GameTooltip:AddDoubleLine(MANA_REGEN, format(manaRegenString, base * 5, combat * 5), 1, 1, 1)
		elseif N.Role == "Melee" then
			local hit =  N.myclass == "HUNTER" and GetCombatRating(CR_HIT_RANGED) or GetCombatRating(CR_HIT_MELEE)
			local hitBonus =  N.myclass == "HUNTER" and GetCombatRatingBonus(CR_HIT_RANGED) or GetCombatRatingBonus(CR_HIT_MELEE)
		
			GameTooltip:AddDoubleLine(STAT_HIT_CHANCE, format(modifierString, hit, hitBonus), 1, 1, 1)
			
			
			local haste = N.myclass == "HUNTER" and GetCombatRating(CR_HASTE_RANGED) or GetCombatRating(CR_HASTE_MELEE)
			local hasteBonus = N.myclass == "HUNTER" and GetCombatRatingBonus(CR_HASTE_RANGED) or GetCombatRatingBonus(CR_HASTE_MELEE)
			
			GameTooltip:AddDoubleLine(STAT_HASTE, format(modifierString, haste, hasteBonus), 1, 1, 1)
		end
		
		local masteryspell
		if GetCombatRating(CR_MASTERY) ~= 0 and GetSpecialization () then
			if N.myclass == "DRUID" then
				if N.Role == "Melee" then
					masteryspell = select(2, GetSpecializationMasterySpells(GetSpecialization ()))
				elseif N.Role == "Tank" then
					masteryspell = select(1, GetSpecializationMasterySpells(GetSpecialization ()))
				else
					masteryspell = GetSpecializationMasterySpells(GetSpecialization ())
				end
			else
				masteryspell = GetSpecializationMasterySpells(GetSpecialization ())
			end
			


			local masteryName, _, _, _, _, _, _, _, _ = GetSpellInfo(masteryspell)
			if masteryName then
				GameTooltip:AddLine' '
				GameTooltip:AddDoubleLine(masteryName, format(modifierString, GetCombatRating(CR_MASTERY), GetCombatRatingBonus(CR_MASTERY)), 1, 1, 1)
			end
		end
		
		GameTooltip:Show()
	end

	local function UpdateTank(self)
				
		-- the 5 is for base miss chance
		if targetlv == -1 then
			basemisschance = (5 - (3*.2))
			leveldifference = 3
		elseif targetlv > playerlv then
			basemisschance = (5 - ((targetlv - playerlv)*.2))
			leveldifference = (targetlv - playerlv)
		elseif targetlv < playerlv and targetlv > 0 then
			basemisschance = (5 + ((playerlv - targetlv)*.2))
			leveldifference = (targetlv - playerlv)
		else
			basemisschance = 5
			leveldifference = 0
		end
		
		if select(2, UnitRace("player")) == "NightElf" then basemisschance = basemisschance + 2 end
		
		if leveldifference >= 0 then
			dodge = (GetDodgeChance()-leveldifference*.2)
			parry = (GetParryChance()-leveldifference*.2)
			block = (GetBlockChance()-leveldifference*.2)
		else
			dodge = (GetDodgeChance()+abs(leveldifference*.2))
			parry = (GetParryChance()+abs(leveldifference*.2))
			block = (GetBlockChance()+abs(leveldifference*.2))
		end
		
		if dodge <= 0 then dodge = 0 end
		if parry <= 0 then parry = 0 end
		if block <= 0 then block = 0 end
		
		if N.myclass == "DRUID" then
			parry = 0
			block = 0
		elseif N.myclass == "DEATHKNIGHT" then
			block = 0
		end
		avoidance = (dodge+parry+block+basemisschance)
		
		Text:SetFormattedText(displayFloatString, hexa.."AVD: "..hexb, avoidance)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateCaster(self)
		if GetSpellBonusHealing() > GetSpellBonusDamage(7) then
			spellpwr = GetSpellBonusHealing()
		else
			spellpwr = GetSpellBonusDamage(7)
		end
		
		Text:SetFormattedText(displayNumberString, hexa.."SP: "..hexb, spellpwr)
		--Setup Tooltip
		self:SetAllPoints(Text)
	end

	local function UpdateMelee(self)
		local base, posBuff, negBuff = UnitAttackPower("player");
		local effective = base + posBuff + negBuff;
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player");
		local Reffective = Rbase + RposBuff + RnegBuff;
			
		if N.myclass == "HUNTER" then
			pwr = Reffective
		else
			pwr = effective
		end
		
		Text:SetFormattedText(displayNumberString, hexa.."AP: "..hexb, pwr)      
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
