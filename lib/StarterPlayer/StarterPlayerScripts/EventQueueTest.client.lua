local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventQueue = require(ReplicatedStorage.EventQueue)

local eventQueue = EventQueue:Create()
eventQueue:Add({ mName = "Msg: Welcome to the Arena"}, -1)
eventQueue:Add({ mName = "Take Turn Goblin" }, 5)
eventQueue:Add({ mName = "Take Turn Hero" }, 4)
eventQueue:Print()
