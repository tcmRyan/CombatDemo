local CEAttack = {}
CEAttack.__index = CEAttack

function CEAttack:Create(scene, owner, target)
	local this = {
		mScene = scene,
		mOwner = owner,
		mTarget = target,
		mName = string.format("CEAttack(_, %s, %s)", owner.mName, target.mName)
	}

	setmetatable(this, self)
	return this
end

function CEAttack:TimePoints(queue)
	local speed = self.mOwner.mSpeed
	return queue:SpeedToTimePoints(speed)
end

function CEAttack:Execute(queue)

	local target = self.mTarget

	-- Already Killed!
	if target.mHP <= 0 then
		-- Get an new random target
		target = self.mScene:GetTarget(self.mOwner)
	end

	local damage = self.mOwner.mAttack
	target.mHP = target.mHP - damage

	local msg = string.format("%s hit for %d damage", target.mName, damage)

	print(msg)

	if target.mHP < 0 then

		local msg = string.format("%s is killed", target.mName)
		print(msg)

		self.mScene:OnDead(target)
	end
end

function CEAttack:Update()
	-- Instant attack, no update required
end

function CEAttack:IsFinished()
	return true
end

return CEAttack
