local StateStack = {}
StateStack.__index = StateStack

function StateStack:Create()
    local this = {
        mStates = {}
    }

    setmetatable(this, self)
    return this
end

function StateStack:Update(dt)
    -- update them and check input
    for k, v in ipairs(self.mStates) do
        v:Update(dt)
    end

    local top = self.mStates[#self.mStates]

    if not top then
        return
    end

    if top:IsDead() then
        table.remove(self.mStates)
        return
    end

    top:HandleInput()
end

return StateStack
