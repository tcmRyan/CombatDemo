local Party = {}
Party.__index = Party

function Party:Create()
	local this = {
		mMembers = {}
	}
	
	setmetatable(this, self)
	return this
end

function Party:Add(member)
	self.mMembers[member.mId] = member
end

function Party:RemoveById(id)
	self.mMembers[id] = nil
end

function Party:Remove(member)
	self:RemoveById(member.id)
end

function Party:ToArray()
	local array = {}

	for k, v in pairs(self.mMembers) do
		table.insert(array, v)
	end

	return array
end

return Party
