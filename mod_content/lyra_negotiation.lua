local negotiation_defs = require "negotiation/negotiation_defs"
local CARD_FLAGS = negotiation_defs.CARD_FLAGS
local EVENT = negotiation_defs.EVENT

local CARDS =
{
    
}

for i, id, carddef in sorted_pairs( CARDS ) do
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
