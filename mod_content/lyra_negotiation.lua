local negotiation_defs = require "negotiation/negotiation_defs"
local CARD_FLAGS = negotiation_defs.CARD_FLAGS
local EVENT = negotiation_defs.EVENT

local CARDS =
{
	professionalism =
	{
		name = "Professionalism",
		cost = 1,
		min_persuasion = 1,
		max_persuasion = 3,
		flags = CARD_FLAGS.DIPLOMACY,
		rarity = CARD_RARITY.BASIC,
	},

	aggression =
	{
		name = "Aggression",
		cost = 1,
		min_persuasion = 1,
		max_persuasion = 4,
		flags = CARD_FLAGS.HOSTILE,
		rarity = CARD_RARITY.BASIC,
	},
	
	aggression_plus_provoked =
	{
		name = "Provoked Aggression",
		desc = "<#UPGRADE>Gain {PROVOKED 1}.</>",
		manual_desc = true,
		flags = CARD_FLAGS.HOSTILE,
		features =
		{
			PROVOKED = 1
		},
	},
		
	steadiness =
	{
		name = "Steadiness",
		cost = 1,
		desc = "Apply {1} {COMPOSURE}.",
		desc_fn = function(self, fmt_str)
            return loc.format(fmt_str, self:CalculateComposureText( self.features.COMPOSURE ))
        end,
        	features =
        	{
         	   COMPOSURE = 3,
        	},
		flags = CARD_FLAGS.MANIPULATE,
		rarity = CARD_RARITY.BASIC,
		target_self = TARGET_ANY_RESOLVE,
	},

	laughing_taunt =
	{
		name = "Laughing Taunt",
		cost = 1,
		desc = "Consume all of your {PROVOKED} and gain {DOMINANCE} equal to that amount.",

		flags = CARD_FLAGS.MANIPULATE,
		rarity = CARD_RARITY.UNCOMMON,
		
		OnPostResolve = function( self, minigame )
			if self.negotiator:HasModifier("PROVOKED") then 
				if self.negotiator:GetModifierStacks("PROVOKED") >= 2 then
					self.negotiator:AddModifier( "DOMINANCE", 2, self)
					self.negotiator:RemoveModifier("PROVOKED", 2)
				end
			end
        end,
        	
	},
}

for i, id, carddef in sorted_pairs( CARDS ) do
	carddef.series = "LYRA"
    Content.AddNegotiationCard( id, carddef )
end

local MODIFIERS = 
{
	CONTRACTOR_MENTALITY =
    {
        name = "Contractor Mentality",
        desc = "When Lyra's core argument is attacked from any source, gain 1 Provoked.",

        modifier_type = MODIFIER_TYPE.CORE,

        target_self = TARGET_FLAG.ARGUMENT,

        event_handlers =
        {
            [ EVENT.ATTACK_RESOLVE ] = function( self, source, target, damage, params, defended )
                if target == self and damage > 0 then
                    self.negotiator:CreateModifier("PROVOKED", 1, self)

                end
            end
        },
    },

    PROVOKED = 
    {
        name = "Provoked",
        desc = "Deal 1 damage to a random argument each turn. Provoked may be spent by other cards for various boons.",
      
        modifier_type = MODIFIER_TYPE.ARGUMENT,
        target_enemy = TARGET_ANY_RESOLVE,
        target_mod = TARGET_MOD.RANDOM1,

        max_resolve = 1,
        max_stacks = 1,
        
        min_persuasion = 1,
        max_persuasion = 1,
        
        event_handlers = 
        {
            [ EVENT.END_PLAYER_TURN ] = function( self, minigame, negotiator )
                self:ApplyPersuasion(self.min_persuasion, self.max_persuasion)
            end
        }    
    }
}

for id, def in pairs( MODIFIERS ) do
    Content.AddNegotiationModifier( id, def )
end
