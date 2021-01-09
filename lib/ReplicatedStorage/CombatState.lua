local CombatState = {}
CombatState.__index = CombatState

function CombatState:Create()
    local this = {}

    setmetatable(this, self)
    return this
end

function CombatState:Enter()
end

function CombatState:Exit()
end

function CombatState:Update()

end

function CombatState:HandleInput()

end

function CombatState:Render()

end


return CombatState
