local CharacterStats = require(script.Parent.CharacterStats)

function NextLevel(level)
	local exponent = 1.5
	local baseXP = 1000
	return math.floor(baseXP * (level ^ exponent))
end

local Actor = {
	EquipSlotLabels = {
		"Weapon:",
		"Armor:",
		"Accessory:",
		"Accessory:",
	},
	EquipSlotId = {
		"weapon",
		"armor",
		"access1",
		"access2",
	},
	ActorStats = {
		"str",
		"spd",
		"int",
	},
	ItemStats = {
		"attack",
		"defense",
		"magic",
		"resist"
	},
	ActorStatLabels = {
		"Strength",
		"Speed",
		"Intelligence",
	},
	ItemStatLabels = {
		"Attack",
		"Defense",
		"Magic",
		"Resist",
	},
	ActionLabels = {
		["attack"] = "Attack",
		["item"] = "Item",
	}
}
Actor.__index = Actor

function Actor:Create(def)
	local this = {
		mDef = def,
		mStats = CharacterStats:Create(def.stats),
		mStatGrowth = def.statGrowth,
		mXp = 0,
		mLevel = 1
	}
	
	this.mNextLevelXP = NextLevel(this.mLevel)
	
	setmetatable(this, self)
	return this
end

function Actor:ReadyToLevelUp()
	return self.mXp >= self.mNextLevelXP
end

function Actor:AddXP(xp)
	self.mXp = self.mXp + xp
	return self:ReadyToLevelUp()
end

function Actor:CreateLevelUp()
	
	local levelup = {
		xp = self.mNextLevelXP,
		level = 1,
		stats = {},
	}
	
	for id, dice in pairs(self.mStatGrowth) do
		levelup.stats[id] = dice:Roll()
	end
	
	-- Additional level up code
	-- e.g. if you want to apply
	-- a bonus every 4 levels
	-- or heal the players MP/HP
	return levelup
end

function Actor:ApplyLevel(levelup)
	self.mXp = self.mXp + levelup.xp
	self.mLevel = self.mLevel + levelup.level
	self.mNextLevelXP = NextLevel(self.mLevel)
	
	assert(self.mXp >= 0)
	
	for k, v in pairs(levelup.stats) do
		self.mStats.mBase[k] = self.mStats.mBase[k] + v
	end
	
	-- Unlock any special abilities etc.
end

function Actor:KO()
	-- Handle KnockOut event
end

return Actor
