local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

PetActionBarFrame:SetFrameStrata('HIGH')

PetActionBarFrame:SetScale(C['nMainbar'].petBar.scale)
PetActionBarFrame:SetAlpha(C['nMainbar'].petBar.alpha)

   -- horizontal/vertical bars

if (C['nMainbar'].petBar.vertical) then
    for i = 2, 10 do
        button = _G['PetActionButton'..i]
        button:ClearAllPoints()
        button:SetPoint('TOP', _G['PetActionButton'..(i - 1)], 'BOTTOM', 0, -8)
    end
end