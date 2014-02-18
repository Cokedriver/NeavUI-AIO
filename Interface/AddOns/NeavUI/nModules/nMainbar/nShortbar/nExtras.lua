local N, C, DB = unpack(select(2, ...)) -- Import:  N - function; C - config; DB - database

if C['nMainbar'].enable ~= true then return end

if (not C['nMainbar'].shortBar and not C['nMainbar'].moveableExtraBars) then
    return
end

    -- moveable bars

for _, frame in pairs({        
    _G['PetActionBarFrame'],
    _G['StanceBarFrame'],
    _G['PossessBarFrame'],
    _G['MultiCastActionBarFrame'],
}) do
    frame:EnableMouse(false)
end

    -- key + alt-key and left mouse to move

for _, button in pairs({        
    _G['PossessButton1'],
    _G['PetActionButton1'],
    _G['StanceButton1'],
}) do
    button:ClearAllPoints()
    button:SetPoint("BOTTOM", DataPanel, "TOP", -165, 140)

    button:SetMovable(true)
    button:SetUserPlaced(true)

    button:RegisterForDrag('LeftButton')
    button:HookScript('OnDragStart', function(self)
        if (IsShiftKeyDown() and IsAltKeyDown()) then
            self:StartMoving() 
        end
    end)

    button:HookScript('OnDragStop', function(self) 
        self:StopMovingOrSizing()
    end)
end