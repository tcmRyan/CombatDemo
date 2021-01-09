local EventQueue = require(script.Parent.EventQueue)
local CETurn = require(script.Parent.CETurn)

local CombatScene = {}
CombatScene.__index = CombatScene

function CombatScene:Create(party, enemies)
	local this = {
		mPartyActors = party or {},
		mEnemyActors = enemies or {},
		mEventQueue = EventQueue:Create()
	}
	
	setmetatable(this, self)
	this:AddTurns(this.mPartyActors)
	this:AddTurns(this.mEnemyActors)
	
	return this
end

function CombatScene:Update()
	self.mEventQueue:Update()
	
	if (self:IsPartyDefeated() or self:IsEnemyDefeated()) then
		-- End of game detected
		self.mEventQueue.mQueue = {}
	else
		-- keep the queue going
		self:AddTurns(self.mPartyActors)
		self:AddTurns(self.mEnemyActors)
	end
end

function CombatScene:AddTurns(actorList)
	for _, v in ipairs(actorList) do
		
		if not self.mEventQueue:ActorHasEvent(v) then
			local event = CETurn:Create(self, v)
			local tp = event:TimePoints(self.mEventQueue)
			self.mEventQueue:Add(event, tp)
		end
	end
end

function CombatScene:IsPartyDefeated()
	
	for _, actor in ipairs(self.mPartyActors) do
		if not actor:IsKOed() then
			return false
		end
	end
	
	return true
end

function CombatScene:IsEnemyDefeated()
	return #self.mEnemyActors == 0
end

function CombatScene:GetTarget(actor)
	
	local targetList = nil
	
	if actor.IsPlayer() then
		targetList = self.mEnemyActors
	else
		targetList = self:GetLivePartyActors()
	end
	
	return targetList[#targetList]
end

function CombatScene:GetLivePartyActors()
	
	local live = {}
	
	for _, actor in ipairs(self.mPartyActors) do
		if not actor:IsKOed() then
			table.insert(live, actor)
		end
	end
	
	return live
end

function CombatScene:OnDead(actor)
	if actor:IsPlayer() then
		actor:KO()
	else
		for i = #self.mEnemyActors, 1, -1 do
			local enemy = self.mEnemyActors[i]
			if actor == enemy then
				table.remove(self.mEnemyActors, i)
			end
		end
	end
	
	-- Remove owned events
	self.mEventQueue:RemoveEventsOwnedBy(actor)
	
	if self:IsPartyDefeated() then
		print("Party losses")
	elseif self:IsEnemyDefeated() then
		print("Party wins")
	
	end
end

return CombatScene
