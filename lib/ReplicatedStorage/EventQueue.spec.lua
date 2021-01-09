local DummyEvent = {}
DummyEvent.__index = DummyEvent

function DummyEvent:Create(scene, owner, target, mName)
    local this = {
        mScene = scene or {},
        mOwner = owner or {},
        mTarget = target or {},
        mName = mName or "DummyEvent"
    }
    setmetatable(this, self)
    return this
end

function DummyEvent:TimePoints(queue)
    return 7
end

function DummyEvent:Execute(queue)
end

function DummyEvent:Update()
end

function DummyEvent:IsFinished()
    return true
end


return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local mock = require(ReplicatedStorage:WaitForChild("mock"))

    local EventQueue = require(script.Parent.EventQueue)
    local gEventQueue = {}

    describe("EventQueue", function()

        beforeEach(function()
            gEventQueue = EventQueue:Create()
        end)

        describe("add events", function()
            local mEvent1 = {}
            local mEvent2 = {}
            local mEvent3 = {}

            beforeEach(function()
                mEvent1 = {mName="Event1"}
                mEvent2 = {mName="Event2"}
                mEvent3 = {mName="Event3"}
                gEventQueue:Add(mEvent2, 1)
                gEventQueue:Add(mEvent3, 10)
                gEventQueue:Add(mEvent1, -1)
            end)

            it("places instant events at the front of the queue", function()
                local front = table.remove(gEventQueue.mQueue, 1)
                expect(front.mName).to.equal("Event1")
            end)

            it("adds the mCountDown to the event", function()
                expect(mEvent2.mCountDown).to.equal(1)
            end)

            it("adds the event at the right spot in the queue", function()
                local expectedQueueOrder = {"Event1", "Event2", "Event3"}
                for i, v in ipairs(gEventQueue.mQueue) do
                    expect(v.mName).to.equal(expectedQueueOrder[i])
                end
            end)
        end)

        describe("ActorHasEvent", function()
            local mEvent1 = {}
            local mEvent2 = {}
            local mEvent3 = {}
            local mEventQueue = {}

            beforeEach(function()
                mEvent1 = {mName="Event1", mOwner="Bob"}
                mEvent2 = {mName="Event2", mOwner="NotBob"}
                mEvent3 = {mName="Event3", mOwner="NotBob"}

                gEventQueue:Add(mEvent2, 1)
                gEventQueue:Add(mEvent3, 10)
                gEventQueue:Add(mEvent1, -1)

                mEventQueue = EventQueue:Create()
                mEventQueue.mQueue = { {
                    mCountDown = 1,
                    mName = "Event2",
                    mOwner = "NotBob"
                  }, {
                    mCountDown = 10,
                    mName = "Event3",
                    mOwner = "NotBob"
                  } }
                mEvent1.Execute = mock.Mock()
                mEvent1.Execute:whenCalled{with={mEventQueue}}

            end)

            it("returns true if the current event is owned by the actor", function()
                mEventQueue.mCurrentEvent = mEvent1
                local hasEvent = mEventQueue:ActorHasEvent("Bob")
                expect(hasEvent).to.equal(true)
            end)

            it("returns true if one or more events are owned by the owner", function()
                local hasEvent = gEventQueue:ActorHasEvent("Bob")
                expect(hasEvent).to.equal(true)

            end)

            it("returns fasle if the current event and no events in the queue are owned by owner", function()
                local hasEvent = gEventQueue:ActorHasEvent("Sally")
                expect(hasEvent).to.equal(false)
            end)
        end)

        describe("RemoveEventsOwnedBy", function ()
            local mEvent1 = {}
            local mEvent2 = {}
            local mEvent3 = {}

            it("removes all events owned by an owner", function()
                mEvent1 = {mName="Event1", mOwner="Bob"}
                mEvent2 = {mName="Event2", mOwner="NotBob"}
                mEvent3 = {mName="Event3", mOwner="NotBob"}

                gEventQueue:Add(mEvent2, 1)
                gEventQueue:Add(mEvent3, 10)
                gEventQueue:Add(mEvent1, -1)

                gEventQueue:RemoveEventsOwnedBy('NotBob')
                expect(#gEventQueue.mQueue).to.equal(1)
            end)
        end)

        describe("Update", function()
            local mEvent1 = {}
            local mEvent2 = {}
            local mEvent3 = {}

            beforeEach(function()
                mEvent1 = DummyEvent:Create("foo", "bar", "Bob", "Event1")
                mEvent2 = DummyEvent:Create("foo", "bar", "NotBob", "Event2")
                mEvent3 = DummyEvent:Create("foo", "bar", "NotBob", "Event3")

                gEventQueue:Add(mEvent2, 1)
                gEventQueue:Add(mEvent3, 10)
                gEventQueue:Add(mEvent1, -1)

            end)

            it("handles an empty queue with no current events", function()
                local eEventQueue = EventQueue:Create()
                eEventQueue:Add(mEvent2, 1)
                eEventQueue:Add(mEvent3, 10)
                eEventQueue:Add(mEvent1, -1)
                expect(function() eEventQueue:Update() end).never.to.throw()
                
            end)

            it("Updates the current event", function()
                mEvent1.Execute = mock.Spy(mEvent1.Execute)
                -- mEvent1.Execute:whenCalled{with={gEventQueue}}

                gEventQueue:Update()
                mEvent1.Execute:assertCallCount(1)
                -- mEvent1.Execute:assertCallMatches{atIndex=1, arguments={gEventQueue}}
                expect(gEventQueue.mCurrentEvent).to.equal(mEvent1)
            end)

            it("decreases the countdown of all the events in the queue", function()
                local event3Countdown = mEvent3.mCountDown
                -- error(event3Countdown)
                for i=3, 1 do
                    gEventQueue:Update()
                end
                for i = #gEventQueue.mQueue, 1 do
                    if gEventQueue.mQueue[i].mName == event3Countdown.mName then
                        expect(gEventQueue.mQueue[i].mCountDown).to.never.equal(event3Countdown)
                    end
                end
                        
            end)

            it("removes the current event if its empty", function()
            end)

            it("removes the front event if current event is nil", function()
                
            end)
        end)
    end)
end
