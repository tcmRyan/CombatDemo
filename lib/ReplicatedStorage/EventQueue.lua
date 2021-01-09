local ReplicatedStorage = game:GetService("ReplicatedStorage")
local inspect = require(ReplicatedStorage.inspect)

local EventQueue = {}
EventQueue.__index = EventQueue

function EventQueue:Create()
	local this = {
		mQueue = {},
		mCurrentEvent = nil
	}

	setmetatable(this, self)
	return this
end

function EventQueue:SpeedToTimePoints(speed)
	local maxSpeed = 255
	speed = math.min(speed, 255)
	local points = maxSpeed - speed
	return math.floor(points)
end

function EventQueue:Add(event, timePoints)
	local queue = self.mQueue

	-- Instant event
	if timePoints == -1 then
		event.mCountDown = -1
		table.insert(queue, 1, event)
	else
		event.mCountDown = timePoints

		-- lop through the events
		for i = 1, #queue do 
			local count = queue[i].mCountDown

			if count > event.mCountDown then
				table.insert(queue, i, event)
				return
			end
		end
		table.insert(queue, event)
	end
end

function EventQueue:ActorHasEvent(actor)
	local current = self.mCurrentEvent or {}

	if current.mOwner == actor then
		return true
	end

	for k, v in ipairs(self.mQueue) do
		if v.mOwner == actor then
			return true
		end
	end

	return false
end

function EventQueue:RemoveEventsOwnedBy(actor)

	for i = #self.mQueue, 1, -1 do
		local v = self.mQueue[i]
		if v.mOwner == actor then
			table.remove(self.mQueue, i)
		end
	end
end

function EventQueue:Clear()
	self.mQueue = {}
	self.mCurrentEvent = nil
end

function EventQueue:IsEmpty()
	return self.mQueue == nil or next(self.mQueue) == nil
end

function EventQueue:Print()

	local queue = self.mQueue

	if self:IsEmpty() then
		print("Event Queue is empty")
		return
	end

	print("Event Queue: ")

	local current = self.mCurrentEvent or {}

	print("Current Event: ", current.mName)

	for k, v in ipairs(queue) do
		local out = string.format("[%d] Event: [%d][%s]", k, v.mCountDown, v.mName)
		print(out)
	end
end

function EventQueue:Update()
	if self.mCurrentEvent ~= nil then
		self.mCurrentEvent:Update()

		if self.mCurrentEvent:IsFinished() then
			self.mCurrentEvent = nil
		else
			return
		end
	elseif self:IsEmpty() then
		return
	else
		-- Need to chose an Event
		local front = table.remove(self.mQueue, 1)
		front:Execute(self)
		self.mCurrentEvent = front
	end

	for _, v in ipairs(self.mQueue) do
		v.mCountDown = math.max(0, v.mCountDown - 1)
	end
end

return EventQueue
