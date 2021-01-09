return function()
    local CharacterStats = require(script.Parent.CharacterStats)

    local baseStats = {
        ["hp_now"] = 300,
        ["hp_max"] = 300,
        ["mp_now"] = 300,
        ["mp_max"] = 300,
        ["strength"] = 10,
        ["speed"] = 10,
        ["intelligence"] = 10,
    }

    local magic_hat = {
        id = 1,
        modifier = {
            add = {
                ["strength"] = 5
            },
        }
    }
    
    local magic_sword = {
        id = 2,
        modifier = {
            add = {
                ["strength"] = 5,
            }
        }
    }
    
    local spell_bravery = {
        id = "bravery",
        modifier = {
            mult = {
                ["strength"] = 0.1
            }
        }
    }
    
    local spell_curse = {
        id = "curse",
        modifier = {
            mult = {
                ["strength"] = -0.5
            }
        }
    }

    describe("CharacterStats", function()
        describe("adding modifiers", function()
            local characterStats = CharacterStats:Create(baseStats)
            characterStats:AddModifier(magic_hat.id, magic_hat.modifier)
            it("correctly adds modifiers to the full stats", function()
                expect(characterStats:Get("strength")).to.equal(15)
            end)
            it("should not modify the base stats", function()
                expect(characterStats:GetBase("strength")).to.equal(10)
            end)
            it("should add the flat totals and then apply multipliers", function()
                characterStats:AddModifier(magic_sword.id, magic_sword.modifier)
                characterStats:AddModifier(spell_bravery.id, spell_bravery.modifier)
                characterStats:AddModifier(spell_curse.id, spell_curse.modifier)
                expect(characterStats:Get("strength")).to.equal(12)
                expect(characterStats:GetBase("strength")).to.equal(10)
            end)
        end)
    end)
end
