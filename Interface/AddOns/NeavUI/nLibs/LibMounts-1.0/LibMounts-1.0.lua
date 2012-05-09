
local MAJOR, MINOR = "LibMounts-1.0", tonumber("20111130073834") or 99999999999999 -- dev version should ovewrite normal version
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

-- define our constants
local AIR, GROUND, WATER, AHNQIRAJ, VASHJIR = "air", "ground", "water", "Temple of Ahn'Qiraj", "Vashj'ir"
-- make them available for lib users
lib.AIR, lib.GROUND, lib.WATER, lib.AHNQIRAJ, lib.VASHJIR = AIR, GROUND, WATER, AHNQIRAJ, VASHJIR

lib.data = LibStub("LibMounts-1.0_Data")

local function assertMount(id)
	local found
	for k, t in pairs(lib.data) do
		if k ~= specialSpeed and t[id] then
			found = true
		end
	end
	if not found then
		local name = GetSpellInfo(id)
		if name then
			print("|cFF33FF99LibMounts-1.0|r: |cFFFF2222"..name.."|r was not found in the mount database. If this is a valid mount, please contact us at http://www.wowace.com/addons/libmounts-1-0/ to get this mount added ASAP")
		else
			print("|cFF33FF99LibMounts-1.0|r: |cFFFF2222"..id.."|r is not a valid Mount Spell ID")
		end
	end
end
--- Retrieves Mount Information including type, speed and location restrictions
-- @param id Spell id of a Mount
-- @usage local ground, air, water, speed, location = LibStub("LibMounts-1.0"):GetMountInfo(id)
-- @return **ground** <<color 00f>>boolean<</color>> true if mount is primarily a ground mount (or can switch between ground and air only modes)
-- @return **air** <<color 00f>>boolean<</color>> true if mount is primarily an air mount (or can switch between air and ground only modes)
-- @return **water** <<color 00f>>boolean<</color>> true if mount is primarily a water mount
-- @return **speed** <<color 00f>>number<</color>> speed of mount if non standard (will always be slower than standard)
-- @return **location** <<color 00f>>string<</color>> location this mount is restricted to (valid returns are "Temple of Ahn'Qiraj" for the bug mounts and "Vashj'ir" for the Seahorse)
-- @return **passagners** <<color 00f>>number<</color>> number of additional passangers a mount can carry. returns nil if 0
function lib:GetMountInfo(id)
	assertMount(id)
	if lib.data["specialLocation"][id] then
		return unpack(lib.data["specialLocation"][id])
	else
		return lib.data["ground"][id], lib.data["air"][id], lib.data["water"][id], lib.data["specialSpeed"][id], nil, lib.data["specialPassenger"][id]
	end
end

lib.normalTypes = {
	[GROUND:lower()] = "ground",
	[AIR:lower()] = "air",
	[WATER:lower()] = "water",
}
lib.specialTypes = {
	[AHNQIRAJ:lower()] = "Temple of Ahn'Qiraj",
	[VASHJIR:lower()] = "Vashj'ir",
}
--- Retrieves a hash table of all mounts in the db of a certain type
-- @param MountType acceptable types include: ground, air, water, Temple of Ahn'Qiraj, Vashj'ir
-- @param table optional table you want the mounts to be stored in
-- @usage local mounts = LibStub("LibMounts-1.0"):GetMountList(type)
-- @return **mountTable** <<color 00f>>hash table<</color>> returns a hash table of mount ID's from the given mount type (mounts with special speeds are not returned)
function lib:GetMountList(MountType, uT)
	local t = uT or {}
	MountType = MountType:lower()
	local normalType = lib.normalTypes[MountType]
	if normalType then
		for id in pairs(lib.data[normalType]) do
			if not lib.data.specialSpeed[id] then
				t[id] = true
			end
		end
	else
		local specialType = lib.specialTypes[MountType]
		if specialType then
			for id, pack in pairs(lib.data.specialLocation) do
				if pack[5] == specialType then
					t[id] = true
				end
			end
		end
	end
	return t
end

--- Retrieves array of Main Mount Types (do not edit this table you have been warned)
-- @usage local MainMountTypes = LibStub("LibMounts-1.0"):GetSpecialMountTypes()
-- @return **MainMountTypes** <<color 00f>>table<</color>> array of Main Mount Types
lib.maintable = {AIR, GROUND, WATER}
lib.mainproxy = {}
setmetatable(lib.mainproxy, {
	__index = lib.maintable,
	__newindex = function (t,k,v)
		error("attempt to change the Main Mount Types Table", 2)
	end
})
function lib:GetMainMountTypes()
	return lib.mainproxy
end

--- Retrieves array of Special Mount Types (do not edit this table you have been warned)
-- @usage local SpecialMountTypes = LibStub("LibMounts-1.0"):GetSpecialMountTypes()
-- @return **SpecialMountTypes** <<color 00f>>table<</color>> array of Special Mount Types
lib.specialtable = {AHNQIRAJ, VASHJIR}
lib.specialproxy = {}
setmetatable(lib.specialproxy, {
	__index = lib.specialtable,
	__newindex = function (t,k,v)
		error("attempt to change the Main Mount Types Table", 2)
	end
})
function lib:GetSpecialMountTypes()
	return lib.specialproxy
end

--- Register for a LibMount-1.0 callback
-- The callback will always be called with the event as the first argument
-- Any arguments to the event will be passed on after that.
-- @name lib.RegisterCallback
-- @class function
-- @paramsig addon, event[, callback]
-- @param addon your addon table/object
-- @param event The event to register for. Currently available: "MOUNT_TYPE_UPDATE" (has primary, secondary and tertiary currently usable mount types as first, second and third arg(lib does not care if the player has mounts for the returned categories))
-- @param callback The callback function to call when the event is triggered (funcref or method, defaults to a method with the event name)
-- @usage LibStub("LibMounts-1.0").RegisterCallback(addon, "MOUNT_TYPE_UPDATE", function(...) print(...) end)

--- Unregister a callback.
-- @name lib.UnregisterCallback
-- @class function
-- @paramsig addon, event
-- @param addon your addon table/object
-- @param event The event to unregister
-- @usage LibStub("LibMounts-1.0").UnregisterCallback(addon, "MOUNT_TYPE_UPDATE")

--- Unregister all callbacks.
-- @name lib.UnregisterAllCallbacks
-- @class function
-- @paramsig addon
-- @param addon your addon table/object
-- @usage LibStub("LibMounts-1.0").UnregisterAllCallbacks(addon)
lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)

lib.frame = lib.frame or CreateFrame('frame')
lib.frame:SetScript("OnEvent", function(self, event, ...) if lib[event] then return lib[event](lib, event, ...) end end)

-- pull in all the localized names from the client
if not lib.Wintergrasp then -- get our localized names
	SetMapByID(501) -- Wintergrasp
	lib.Wintergrasp = select(GetCurrentMapZone(), GetMapZones(GetCurrentMapContinent()))
	for id=1, GetNumWorldPVPAreas() do
		if select(2, GetWorldPVPAreaInfo(id)) == lib.Wintergrasp then
			lib.WintergraspPVPid = id
			break
		end
	end
end

if not lib.vashzones then
	lib.vashzones = {}
	SetMapByID(613) -- Vashj'ir
	lib.vashzones[select(GetCurrentMapZone(), GetMapZones(GetCurrentMapContinent()))] = true
	SetMapByID(614) -- Abyssal Depths
	lib.vashzones[select(GetCurrentMapZone(), GetMapZones(GetCurrentMapContinent()))] = true
	SetMapByID(610) -- Kelp'thar Forest
	lib.vashzones[select(GetCurrentMapZone(), GetMapZones(GetCurrentMapContinent()))] = true
	SetMapByID(615) -- Shimmering Expanse
	lib.vashzones[select(GetCurrentMapZone(), GetMapZones(GetCurrentMapContinent()))] = true
end


function lib:PLAYER_REGEN_DISABLED()
	lib.frame:UnregisterEvent('SPELL_UPDATE_USABLE')
end

function lib:PLAYER_REGEN_ENABLED()
	lib.frame:RegisterEvent('SPELL_UPDATE_USABLE')
	lib:SPELL_UPDATE_USABLE()
end

-- This is our selection function can probably be optimized somehow but this is in a failry easily readbale format
function lib:SPELL_UPDATE_USABLE(...)
	local newstatePrimary, newstateSecondary, newstateTertiary
	if IsIndoors() then
		newstatePrimary = nil
		newstateSecondary = nil
	elseif lib.vashzones[GetRealZoneText()] then -- if we are in vashj
		if IsSwimming() or IsSubmerged() then
			if IsUsableSpell(75207) then
				if IsSubmerged() then -- check if we can air mount on the surface Spell id is that of the Black Proto-Drake
					newstatePrimary = VASHJIR
					newstateSecondary = WATER
					newstateTertiary = GROUND
				else
					newstatePrimary = AIR
					newstateSecondary = VASHJIR
					newstateTertiary = WATER
				end
			else
				newstatePrimary = WATER
				newstateSecondary = GROUND
			end
		elseif IsFlyableArea() and IsUsableSpell(60025) and IsUsableSpell(43688) then -- makes sure that air and ground mounts are sumonable here otherwise we are in a cave
			newstatePrimary = AIR
			newstateSecondary = GROUND
		elseif IsUsableSpell(43688) then
			newstatePrimary = GROUND
			newstateSecondary = nil
		end
	elseif IsSwimming() then
		if IsUsableSpell(59976) then -- check if we can air mount on the surface Spell id is that of the Black Proto-Drake
			newstatePrimary = AIR
			newstateSecondary = WATER
			newstateTertiary = GROUND
		else
			newstatePrimary = WATER
			newstateSecondary = GROUND
		end
	elseif IsFlyableArea() and IsUsableSpell(60025) then -- we use the check since azeroth is flyable but not if you do not have the cata expansion
		newstatePrimary = AIR
		newstateSecondary = GROUND
	elseif IsUsableSpell(26054) then -- use a bugmount to see if we are in AQ
		newstatePrimary = AHNQIRAJ
		newstateSecondary = GROUND
	elseif IsUsableSpell(43688) then -- specifically check a ground mount
		newstatePrimary = GROUND
		newstateSecondary = nil
	end
	
	-- Wintergrasp fix since blizzard can't makeup their minds
	if lib.Wintergrasp == GetRealZoneText() and IsOutdoors() then
		if select(3,GetWorldPVPAreaInfo(lib.WintergraspPVPid)) then
			newstatePrimary = GROUND
			newstateSecondary = nil
		else
			newstatePrimary = AIR
			newstateSecondary = GROUND
		end
	end
	
	-- check if anything changed and fire and update if it did
	if newstatePrimary ~= lib.statePrimary or newstateSecondary ~= lib.stateSecondary  or newstateTertiary ~= lib.stateTertiary then
		lib.statePrimary = newstatePrimary
		lib.stateSecondary = newstateSecondary
		lib.stateTertiary = newstateTertiary
		--print("LibMounts States", newstatePrimary, newstateSecondary, newstateTertiary)
		lib.callbacks:Fire("MOUNT_TYPE_UPDATE", newstatePrimary, newstateSecondary, newstateTertiary)
	end
end
lib.UPDATE_WORLD_STATES = lib.SPELL_UPDATE_USABLE

function lib.callbacks:OnUsed(target, eventname)
	if eventname == "MOUNT_TYPE_UPDATE" then
		lib.frame:RegisterEvent("SPELL_UPDATE_USABLE")
		lib.frame:RegisterEvent("UPDATE_WORLD_STATES")
		lib.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
		lib.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		lib:SPELL_UPDATE_USABLE()
	end
end

function lib.callbacks:OnUnused(target, eventname)
	if eventname == "MOUNT_TYPE_UPDATE" then
		lib.frame:UnregisterEvent("SPELL_UPDATE_USABLE")
		lib.frame:UnregisterEvent("UPDATE_WORLD_STATES")
		lib.frame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		lib.frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

--- forces a currently usable mount type update and also returns primary and secondary currently usable mount types
-- @usage local primary, secondary = LibStub("LibMounts-1.0"):GetCurrentMountType()
-- @return **primary** <<color 00f>>string<</color>> Primary currently usable mount type
-- @return **secondary** <<color 00f>>string<</color>> Secondary currently usable mount type
-- @return **tertiary** <<color 00f>>string<</color>> Tertiary currently usable mount type
function lib:GetCurrentMountType()
	lib:SPELL_UPDATE_USABLE()
	return lib.statePrimary, lib.stateSecondary, lib.stateTertiary
end
