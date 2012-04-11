local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['mainbar'].enable ~= true then return end

MultiBarBottomLeft:SetAlpha(C['mainbar'].multiBarBottomLeft.alpha)
