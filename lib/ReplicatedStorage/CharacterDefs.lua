local Dice = require(script.Parent.Dice)
local Growth = require(script.Parent.Growth)

local CharacterDefs = {
	fighter = {
		id = "fighter",
		stats = {
			['hp_now'] = 300,
			['hp_max'] = 300,
			['mp_now'] = 300,
			['mp_max'] = 300,
			['str'] = 10,
			['spd'] = 10,
			['int'] = 10,
		},
		statGrowth = {
			["hp_max"] = Dice:Create("4d50+100"),
			["mp_max"] = Dice:Create("2d50+100"),
			["str"] = Growth.fast,
			["spd"] = Growth.fast,
			["int"] = Growth.med
		},
		name = "McFighty",
		actions = { "attack", "item" },
		portrait = "fixme.png",	
	},
	mage =
		{
			id = "mage",
			stats =
			{
				["hp_now"] = 200,
				["hp_max"] = 200,
				["mp_now"] = 250,
				["mp_max"] = 250,
				["strength"] = 8,
				["speed"] = 10,
				["intelligence"] = 20,
			},
			statGrowth =
			{
				["hp_max"] = Dice:Create("3d40+100"),
				["mp_max"] = Dice:Create("4d50+100"),
				["strength"] = Growth.med,
				["speed"] = Growth.med,
				["intelligence"] = Growth.fast,
			},
			portrait = "mage_portrait.png",
			name = "McCasty",
			actions = { "attack", "item"}
		},
}

return CharacterDefs
