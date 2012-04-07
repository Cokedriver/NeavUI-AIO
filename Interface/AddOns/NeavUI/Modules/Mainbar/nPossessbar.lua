local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

PossessBarFrame:SetScale(C['mainbar'].possessBar.scale)
PossessBarFrame:SetAlpha(C['mainbar'].possessBar.alpha)
