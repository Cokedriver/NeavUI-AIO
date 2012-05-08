local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

MultiBarBottomLeft:SetAlpha(C['nMainbar'].multiBarBottomLeft.alpha)
