local N, C, DB = unpack(select(2, ...)) -- Import:  B - function; C - config; DB - Database

if C['nCore'].selfbuffs.enable ~= true then return end

--[[

	All Credit for Selfbuffs.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

--------------------------------------------------------------------------------------------
-- Spells that should be shown with an icon in the middle of the screen when not buffed.
--------------------------------------------------------------------------------------------
	 
remindbuffs = {
    DRUID = {
        1126,  -- mark of the wild
    },
	PRIEST = {
		588, -- inner fire
		73413, -- inner will
	},
	HUNTER = {
		13165, -- hawk
		5118, -- cheetah
		13159, -- pack
		20043, -- wild
		82661, -- fox
		93435, -- roar of courage (hunter pet)
	},
	
	MAGE = {
		7302, -- frost armor
		6117, -- mage armor
		30482, -- molten armor
	},
	
	PALADIN = {
		20217, -- kings
		19740, -- might
	},
	
	WARLOCK = {
		28176, -- fel armor
		687, -- demon armor
	},
	SHAMAN = {
		52127, -- water shield
		324, -- lightning shield
		974, -- earth shield
		31634, -- strength of earth totem
	},
	WARRIOR = {
		469, -- commanding Shout
		6673, -- battle Shout
	},
	DEATHKNIGHT = {
		57330, -- horn of Winter
	},
}

remindenchants = {
	ROGUE = {
		2842, -- poison
	},
	SHAMAN = {
		8024, -- flametongue
		8232, -- windfury
		51730, -- earthliving
	},
}

-- Nasty stuff below. Don't touch.
local buffs = remindbuffs[N.myclass]
local enchants = remindenchants[N.myclass]
local sound 

if (buffs and buffs[1]) then
	local function OnEvent(self, event)	
		if (event == 'PLAYER_LOGIN' or event == 'LEARNED_SPELL_IN_TAB') then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if (usable or nomana) then
					self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					break
				end
			end
			if (not self.icon:GetTexture() and event == 'PLAYER_LOGIN') then
				self:UnregisterAllEvents()
				self:RegisterEvent('LEARNED_SPELL_IN_TAB')
				return
			elseif (self.icon:GetTexture() and event == 'LEARNED_SPELL_IN_TAB') then
				self:UnregisterAllEvents()
				self:RegisterEvent('UNIT_AURA')
				self:RegisterEvent('PLAYER_LOGIN')
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
				self:RegisterEvent('PLAYER_REGEN_DISABLED')
			end
		end
					
		if (UnitAffectingCombat('player') and not UnitInVehicle('player')) then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				if (name and UnitBuff('player', name)) then
					self:Hide()
					sound = true
					return
				end
			end
			self:Show()
			if C['nCore'].selfbuffs.playsound == true and sound == true then
				PlaySoundFile(C['nMedia'].warnsound)
				sound = false
			end
		else
			self:Hide()
			sound = true
		end
    end
	
	local frame = CreateFrame('Frame', nil, UIParent)
    frame:SetPoint('CENTER', UIParent, 0, 175)
    frame:SetSize(50, 50)
	frame:CreateBeautyBorder(12)
	frame:SetBeautyBorderTexture('white')
	
	if C['nMedia'].border == "Default" then
		frame:SetBeautyBorderColor(0.38, 0.38, 0.38)		
	elseif C['nMedia'].border == "Classcolor" then
		frame:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
	elseif C['nMedia'].border == "Custom" then
		frame:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
	end	
	
	frame:Hide()
	
	frame.icon = frame:CreateTexture(nil, 'BACKGROUND')
	frame.icon:SetPoint('CENTER', frame)
	frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.icon:SetSize(50, 50)
    frame.icon:SetParent(frame)
		
	 
	frame:RegisterEvent('UNIT_AURA')
	frame:RegisterEvent('PLAYER_LOGIN')
	frame:RegisterEvent('PLAYER_REGEN_ENABLED')
	frame:RegisterEvent('PLAYER_REGEN_DISABLED')
	frame:RegisterEvent('UNIT_ENTERING_VEHICLE')
	frame:RegisterEvent('UNIT_ENTERED_VEHICLE')
	frame:RegisterEvent('UNIT_EXITING_VEHICLE')
	frame:RegisterEvent('UNIT_EXITED_VEHICLE')
	
	frame:SetScript('OnEvent', OnEvent)
		

end

if (enchants and enchants[1]) then
	local sound
	local currentlevel = UnitLevel("player")

	local function EnchantsOnEvent(self, event)
		if (event == "PLAYER_LOGIN") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "PLAYER_LEVEL_UP") then
			if N.myclass == "ROGUE" then
				self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
				self:UnregisterEvent("PLAYER_LEVEL_UP")
				self.icon:SetTexture(select(3, GetSpellInfo(enchants[1])))
				return
			elseif N.myclass == "SHAMAN" then
				local ptt = GetPrimaryTalentTree()
				if ptt and ptt == 3 and currentlevel > 53 then
					self.icon:SetTexture(select(3, GetSpellInfo(enchants[3])))
				elseif ptt and ptt == 2 and currentlevel > 31 then
					self.icon:SetTexture(select(3, GetSpellInfo(enchants[2])))
				else
					self.icon:SetTexture(select(3, GetSpellInfo(enchants[1])))
				end
				return
			end
		end

		if (N.myclass == "ROGUE" or N.myclass =="SHAMAN") and currentlevel < 10 then return end

		if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
			local mainhand, _, _, offhand, _, _, thrown = GetWeaponEnchantInfo()
			if N.myclass == "ROGUE" then
				local itemid = GetInventoryItemID("player", GetInventorySlotInfo("RangedSlot"))
				if itemid and select(7, GetItemInfo(itemid)) == INVTYPE_THROWN and currentlevel > 61 then
					if mainhand and offhand and thrown then
						self:Hide()
						sound = true
						return
					end
				else
					if mainhand and offhand then
						self:Hide()
						sound = true
						return
					end
				end
			elseif N.myclass == "SHAMAN" then
				local itemid = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"))
				if itemid and select(6, GetItemInfo(itemid)) == ENCHSLOT_WEAPON then
					if mainhand and offhand then
						self:Hide()
						sound = true
						return
					end
				elseif mainhand then
					self:Hide()
					sound = true
					return
				end
			end
			self:Show()
			if C['nCore'].selfbuffs.playsound == true and sound == true then
				PlaySoundFile(C['nMedia'].warnsound)
				sound = false
			end
		else
			self:Hide()
			sound = true
		end
	end

	local frame = CreateFrame('Frame', nil, UIParent)
    frame:SetPoint('CENTER', UIParent, 0, 150)
    frame:SetSize(50, 50)
	frame:CreateBeautyBorder(12)
	frame:SetBeautyBorderTexture('white')
	
	if C['nMedia'].border == "Default" then
		frame:SetBeautyBorderColor(0.38, 0.38, 0.38)		
	elseif C['nMedia'].border == "Classcolor" then
		frame:SetBeautyBorderColor(N.ccolor.r, N.ccolor.g, N.ccolor.b)
	elseif C['nMedia'].border == "Custom" then
		frame:SetBeautyBorderColor(C['nMedia'].color.r, C['nMedia'].color.g, C['nMedia'].color.b)		
	end	
	
	frame:Hide()
	
	frame.icon = frame:CreateTexture(nil, 'BACKGROUND')
	frame.icon:SetPoint('CENTER', frame)
	frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	frame.icon:SetSize(45, 45)
    frame.icon:SetParent(frame)
		
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_LEVEL_UP")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	frame:RegisterEvent("UNIT_EXITED_VEHICLE")

	frame:SetScript("OnEvent", EnchantsOnEvent)
end
