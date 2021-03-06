local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nRaidframes'].enable ~= true then return end

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "NeavUI was unable to locate oUF install.")

local timer = {}

oUF.Tags.Events['status:raid'] = 'PLAYER_FLAGS_CHANGED UNIT_CONNECTION'
oUF.Tags.Methods['status:raid'] = function(unit)
    local name = UnitName(unit)
    if (UnitIsAFK(unit) or not UnitIsConnected(unit)) then
        if (not timer[name]) then
            timer[name] = GetTime()
        end

        local time = (GetTime() - timer[name])

        return N.FormatTime(time)
    elseif timer[name] then
        timer[name] = nil
    end
end

oUF.Tags.Events['role:raid'] = 'PARTY_MEMBERS_CHANGED PLAYER_ROLES_ASSIGNED'
if (not oUF.Tags['role:raid']) then
    oUF.Tags.Methods['role:raid'] = function(unit)
        local role = UnitGroupRolesAssigned(unit)
        if (role) then
            if (role == 'TANK') then
                role = '>'
            elseif (role == 'HEALER') then
                role = '+'
            elseif (role == 'DAMAGER') then
                role = '-'
            elseif (role == 'NONE') then
                role = ''
            end

            return role
        else
            return ''
        end
    end
end

oUF.Tags.Events['name:raid'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['name:raid'] = function(unit)
    local name = UnitName(unit)
    return N.utf8sub(name, C['nRaidframes'].units.raid.nameLength)
end