local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - Database

--[[

	All Credit for DPS.lua goes to Tuks.
	Tukui = http://www.tukui.org/download.php.
	Edited by Cokedriver.
	
]]

if C['nData'].enable ~= true then return end

if C['nData'].dps_text and C['nData'].dps_text > 0 then
	local events = {SWING_DAMAGE = true, RANGE_DAMAGE = true, SPELL_DAMAGE = true, SPELL_PERIODIC_DAMAGE = true, DAMAGE_SHIELD = true, DAMAGE_SPLIT = true, SPELL_EXTRA_ATTACKS = true}
	local DPS_FEED = CreateFrame('Frame')
	local player_id = UnitGUID('player')
	local dmg_total, last_dmg_amount = 0, 0
	local cmbt_time = 0

	local pet_id = UnitGUID('pet')
     
	local dText = DataPanel:CreateFontString(nil, 'OVERLAY')
	dText:SetFont(C['nMedia'].font, C['nData'].fontsize,'THINOUTLINE')
	dText:SetText("DPS: ", '0')

	N.PP(C['nData'].dps_text, dText)

	DPS_FEED:EnableMouse(true)
	DPS_FEED:SetFrameStrata('BACKGROUND')
	DPS_FEED:SetFrameLevel(3)
	DPS_FEED:SetHeight(20)
	DPS_FEED:SetWidth(100)
	DPS_FEED:SetAllPoints(dText)

	DPS_FEED:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	DPS_FEED:RegisterEvent('PLAYER_LOGIN')

	DPS_FEED:SetScript('OnUpdate', function(self, elap)
		if UnitAffectingCombat('player') then
			cmbt_time = cmbt_time + elap
		end
       
		dText:SetText(getDPS())
	end)
     
	function DPS_FEED:PLAYER_LOGIN()
		DPS_FEED:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		DPS_FEED:RegisterEvent('PLAYER_REGEN_ENABLED')
		DPS_FEED:RegisterEvent('PLAYER_REGEN_DISABLED')
		DPS_FEED:RegisterEvent('UNIT_PET')
		player_id = UnitGUID('player')
		DPS_FEED:UnregisterEvent('PLAYER_LOGIN')
	end
     
	function DPS_FEED:UNIT_PET(unit)
		if unit == 'player' then
			pet_id = UnitGUID('pet')
		end
	end
	
	-- handler for the combat log. used http://www.wowwiki.com/API_COMBAT_LOG_EVENT for api
	function DPS_FEED:COMBAT_LOG_EVENT_UNFILTERED(...)		   
		-- filter for events we only care about. i.e heals
		if not events[select(2, ...)] then return end

		-- only use events from the player
		local id = select(4, ...)
		   
		if id == player_id or id == pet_id then
			if select(2, ...) == "SWING_DAMAGE" then
				if B.toc < 40200 then
					last_dmg_amount = select(10, ...)
				else
					last_dmg_amount = select(12, ...)
				end
			else
				if B.toc < 40200 then
					last_dmg_amount = select(13, ...)
				else
					last_dmg_amount = select(15, ...)
				end
			end
			dmg_total = dmg_total + last_dmg_amount
		end       
	end
     
	function getDPS()
		if (dmg_total == 0) then
			return (hexa.."DPS"..hexb..' 0')
		else
			return string.format(hexa.."DPS: "..hexb..'%.1f ', (dmg_total or 0) / (cmbt_time or 1))
		end
	end

	function DPS_FEED:PLAYER_REGEN_ENABLED()
		dText:SetText(getDPS())
	end
	
	function DPS_FEED:PLAYER_REGEN_DISABLED()
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end
     
	DPS_FEED:SetScript('OnMouseDown', function (self, button, down)
		cmbt_time = 0
		dmg_total = 0
		last_dmg_amount = 0
	end)
end