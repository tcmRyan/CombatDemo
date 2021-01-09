--[[
	Item properties:
	name: The Name Displayed to the user
	description: A detailed description for the user to read
	type:
		meleeWpn,
		rangeWpn,
		collectible,
		armour
	Slot:
		head,
		shoulder,
		chest,
		legs,
		feet,
		mainhand,
        offhand
    stats: 
	
		
--]]
local ItemDB = {
    [-1] = {
        name = "",
        description = "",
        special = "",
        stats = {
            strength = 0,
            speed = 0,
            intelligence = 0,
            attack = 0,
            defense = 0,
            magic = 0,
            resist = 0,
        }
    },
	{
		name = "Pairie Dog Meat",
		description = "This looks like it could cook nicely",
		type = "collectible",
		thumbnail = "rbxassetid://4953585861"
	},
	{
		name = "Message to Godwin",
		description = "An introduction to Godwin and a promise for new clothes",
        type = "key",
    },
    {
		name = "Large Stick",
        description = "A straight stick",
        stats = {
            attack = 10,
        },
	    type = "weapon",
	},
    {
		name = "Rusty Hachet",
        description = "This old thing isn't pretty",
        stats = {
            attack = 10
        },
		type = "weapon",
		thumbnail = ""
	},
	{
		name = "Prairie Dog Paw",
		description = "The paw of a Prairie Dog",
		type = "collectible",
		thumbnail = "rbxassetid://4953584475"
    },
    {
        name = "Bandage",
        type = "useable",
        description = "Stops bleeding and heals a little HP"
    }
}

local EmptyItem = ItemDB[-1]

local function DoesItemHaveStats(item)
    return item.type == "weapon" or
           item.type == "accessory" or
           item.type == "armor"
end

--[[
  If any stat is missing add it and set it to
  the values in EmptyItem
--]]
for _, v in ipairs(ItemDB) do
    if DoesItemHaveStats(v) then
        v.stats = v.stats or {}
        local stats = v.stats
        for key, value in ipairs(EmptyItem) do
            stats[key] = stats[key] or v.stats
        end
    end
end

return ItemDB
