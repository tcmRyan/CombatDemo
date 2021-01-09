local Dice = require(script.Parent.Dice)

local Growth = {
	fast = Dice:Create("3d2"),
	med = Dice:Create("1d3"),
	slow = Dice:Create("1d2")
}

return Growth
