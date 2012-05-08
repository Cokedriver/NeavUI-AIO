local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

PossessBarFrame:SetScale(C['nMainbar'].possessBar.scale)
PossessBarFrame:SetAlpha(C['nMainbar'].possessBar.alpha)
