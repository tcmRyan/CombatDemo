local CEAttack = require(script.Parent.CEAttack)

local CETurn = {}
CETurn.__index = CETurn

function CETurn:Create(scene, owner)
	local this = {
		mScene = scene,
		mOwner = owner,
		mName = string.format("CETurn(_, %s", owner.mName)
	}
	setmetatable(this, self)
	return this
	
end

function CETurn:TimePoints(queue)
	local speed = self.mOwner.mSpeed
	return queue:SpeedToTimePoints(speed)
end

function CETurn:Execute(queue)
	
	-- Choose a random enemy Target
	local target = self.mScene:GetTarget(self.mOwner)
	
	local msg = string.format("%s decides to attack %s", self.mOwner.mName, target.mName)
	print(msg)
	local event = CEAttack:Create(self.mScene, self.mOwner, target)
	local tp = event:TimePoints(queue)
	queue:Add(event, tp)
end

function CETurn:Update()
	
end

function CETurn:IsFinished()
	return true
end

return CETurn
