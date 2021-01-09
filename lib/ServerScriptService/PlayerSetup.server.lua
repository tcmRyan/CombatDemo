local Party = require(script.Parent.Party)
local World = require(script.Parent.World)

local function OnPlayerJoin(player)
    local msg = string.format("Player %s Joined", player.DisplayName)
    print(msg)
    local gWorld = World:Create()



end

game.Players.PlayerAdded:Connect(OnPlayerJoin)
