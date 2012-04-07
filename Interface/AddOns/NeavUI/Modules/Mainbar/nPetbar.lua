local N, C = unpack(select(2, ...)) -- Import:  N - function; C - config

PetActionBarFrame:SetFrameStrata('HIGH')

PetActionBarFrame:SetScale(C['mainbar'].petBar.scale)
PetActionBarFrame:SetAlpha(C['mainbar'].petBar.alpha)

   -- horizontal/vertical bars

if (C['mainbar'].petBar.vertical) then
    for i = 2, 10 do
        button = _G['PetActionButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
    end
end