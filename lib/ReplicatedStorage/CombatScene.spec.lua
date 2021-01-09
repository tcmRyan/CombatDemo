return function()
    local CombatScene = require(script.Parent.CombatScene)
    local party = {
        -- our hero
        {
            mName = "hero",
            mSpeed = 3,
            mAttack = 2,
            mHP = 5,
            IsPlayer = function() return true end,
            IsKOed = function(self) return self.mHP <= 0 end,
        },
    }
    local enemies = {
        -- enemies goblin
        {
            mName = "goblin",
            mSpeed = 2,
            mAttack = 2,
            mHP = 5,
            IsPlayer = function() return false end,
            IsKOed = function(self) return self.mHP <= 0 end,
        },
    }
    describe("Combat Scene", function()
        describe("creation", function()
            it("can be created with only party members", function()
                expect(CombatScene:Create(party)).to.be.ok()
            end)
            it("can be created with only enemies", function()
                expect(CombatScene:Create(nil, enemies)).to.be.ok()
            end)
        end)
        describe("combat scene integration", function()
            it("should continue taking turns until party or enemies are defeated", function()
                local gCombatScene = CombatScene:Create(party, enemies)
                gCombatScene:Update()

                -- while(not(gCombatScene:IsPartyDefeated() or gCombatScene:IsEnemyDefeated())) do
                --     gCombatScene:Update()
                -- end
                -- expect(gCombatScene.mEventQueue.mQueue).to.equal({})
            end)
        end)

		describe("check if the party is defeated", function()
			it("should return false if the members in the party are alive", function()
				local gCombatScene = CombatScene:Create(party, enemies)
				local result = 0
				if gCombatScene:IsPartyDefeated() then
					result = 1
				end
				expect(gCombatScene:IsPartyDefeated()).to.be.a("boolean")
				expect(result).to.equal(0)
            end)
            
            it("should return true if all members of the party have less then 0 hp", function()
                local partyKO = {
                    -- our hero
                    {
                        mName = "hero",
                        mSpeed = 3,
                        mAttack = 2,
                        mHP = -3,
                        IsPlayer = function() return true end,
                        IsKOed = function(self) return self.mHP <= 0 end,
                    },
                }
                local gCombatScene = CombatScene:Create(partyKO, enemies)
                local result = 0
				if gCombatScene:IsPartyDefeated() then
					result = 1
				end
				expect(gCombatScene:IsPartyDefeated()).to.be.a("boolean")
				expect(result).to.equal(1)
            end)
		end)
		describe("check if the enemy is defeated", function()
			it("should return false if the enemies are alive", function()
				local gCombatScene = CombatScene:Create(party, enemies)
				local result = 0
				if gCombatScene:IsEnemyDefeated() then
					result = 1
				end
				expect(gCombatScene:IsEnemyDefeated()).to.be.a("boolean")
				expect(result).to.equal(0)
			end)

			it("should return true if all enemies have less then 0 hp", function()
				local enemyKO = {}
				local gCombatScene = CombatScene:Create(party, enemyKO)
				local result = 0
				if gCombatScene:IsEnemyDefeated() then
					result = 1
				end
				expect(gCombatScene:IsEnemyDefeated()).to.be.a("boolean")
				expect(result).to.equal(1)
			end)
        end)
        
        describe("adds turns to the actors", function()
            local gCombatScene = CombatScene:Create(party, enemies)
            it("creates an event if no turns are in the actors turns", function()
                gCombatScene:AddTurns(gCombatScene.mPartyActors)
                gCombatScene:AddTurns(gCombatScene.mEnemyActors)
            end)
        end)
    end)
end
