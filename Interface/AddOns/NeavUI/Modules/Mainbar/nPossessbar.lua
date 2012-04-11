local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end

PossessBarFrame:SetScale(C['mainbar'].possessBar.scale)
PossessBarFrame:SetAlpha(C['mainbar'].possessBar.alpha)
