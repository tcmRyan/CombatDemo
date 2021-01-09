return function()
	local Actor = require(script.Parent.Actor)
	local Growth = require(script.Parent.Growth)
	local Dice = require(script.Parent.Dice)
	local heroDef =
	{
		stats = {
			["hp_max"] = 200,
			["mp_max"] = 100,
			['str'] = 10,
			['spd'] = 10,
			['int'] = 10,
		},
		statGrowth =
		{
			["hp_max"] = Dice:Create("4d50+100"),
			["mp_max"] = Dice:Create("2d50+100"),
			["str"] = Growth.fast,
			["spd"] = Growth.fast,
			["int"] = Growth.med,
		},
		-- additional actor definition info
	}


	describe("Actor", function()
		local actor = Actor:Create(heroDef)

		describe("creation", function()
			it("should have base stats populated from a table when created", function()
				expect(heroDef.stats['int']).to.equal(actor.mStats:GetBase('int'))
				expect(heroDef.stats['spd']).to.equal(actor.mStats:GetBase('spd'))
				expect(heroDef.stats['str']).to.equal(actor.mStats:GetBase('str'))
				expect(actor.mStats:GetBase('hp_max')).to.equal(200)
			end)
			it("should have stat growth configured", function()
				expect(heroDef.statGrowth).to.equal(actor.mStatGrowth)
			end)
			it("should set the xp required for next level", function()
				local baseXp = 1000
				local level = 1
				local level2XP = math.floor(baseXp * (level ^ 1.5))
				expect(actor.mNextLevelXP).to.equal(level2XP)
			end)
			it("should retain the orginal table for reference", function() 
				expect(heroDef).to.equal(actor.mDef)
			end)
		end)
		describe("adding XP", function()
			-- make sure we reset the actor so the tests are idempotent
			it("should return false if the user does not have enough experience", function()
				actor = Actor:Create(heroDef)
				expect(actor:AddXP(999)).to.equal(false)
			end)
			it("should return true if the user has enough", function()
				actor = Actor:Create(heroDef)
				expect(actor:AddXP(1000)).to.equal(true)
			end)
		end)

		describe("create a new level", function()
			it("should create a table based on stat growth", function()
				actor = Actor:Create(heroDef)
				local levelUp = actor:CreateLevelUp()
				expect(levelUp.stats["hp_max"]).to.be.near(200, 100)
				expect(levelUp.stats["str"]).to.be.near(3,3)
				expect(levelUp.stats["int"]).to.be.near(2,1)
			end)
		end)
	end)
end
