local negotiation_defs = require "negotiation/negotiation_defs"
local CARD_FLAGS = negotiation_defs.CARD_FLAGS
local EVENT = negotiation_defs.EVENT

local CARDS =
{
	professionalism =
	{
		name = "Professionalism",
		cost = 1,
		flavour = "'If we come to an agreement, we can all walk away happy.'",
		min_persuasion = 1,
		max_persuasion = 3,
		flags = CARD_FLAGS.DIPLOMACY,
		rarity = CARD_RARITY.BASIC,
		icon = "negotiation/fast_talk.tex",
	},

	aggression =
	{
		name = "Aggression",
		cost = 1,
		flavour = "'I don't work for you. I work for money.'",
		min_persuasion = 1,
		max_persuasion = 4,
		flags = CARD_FLAGS.HOSTILE,
		rarity = CARD_RARITY.BASIC,
		icon = "negotiation/threaten.tex",
	},
		
	steadiness =
	{
		name = "Steadiness",
		cost = 1,
		desc = "Apply {1} {COMPOSURE}.",
		flavour = "'I've been through worse.'",
		manual_desc = true,
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
		icon = "negotiation/deflection.tex",
	},
	
	the_contract =
	{
		name = "The Contract",
		cost = 1,
		desc = "{IMPROVISE} from a pool of unique cards.",
		flavour = "'Where I'm from, contracts are everything.'",
		manual_desc = true,
		flags = CARD_FLAGS.MANIPULATE,
		rarity = CARD_RARITY.BASIC,
		icon = "negotiation/a_hot_tip.tex",
		pool_size = 3,
		
		pool_cards = {"improvise_upfront_fee", "improvise_clear_violation", "improvise_reexamine", "improvise_financial_security", "improvise_refine_agreement", "improvise_corrections", },
		
		OnPostResolve = function( self, minigame, targets)
            local cards = ObtainWorkTable()

            cards = table.multipick( self.pool_cards, self.pool_size )
            for k,id in pairs(cards) do
                cards[k] = Negotiation.Card( id, self.owner  )
            end
            minigame:ImproviseCards( cards, 1 )
            ReleaseWorkTable(cards)
        end,
	},
	
	improvise_upfront_fee =
	{
		name = "Upfront Fee",
		cost = 0,
		desc = "Gain 10 shills.",
		flavour = "'Just a little something to help grease the wheels, you know?'",
		manual_desc = true,
		flags = CARD_FLAGS.HOSTILE | CARD_FLAGS.EXPEND,
		rarity = CARD_RARITY.UNIQUE,
		icon = "negotiation/degrading_nepotism.tex",
		min_persuasion = 2,
		max_persuasion = 3,
		money = 10,
		OnPostResolve = function( self )
            self.engine:ModifyMoney( self.money )
        end,
	},
	
	improvise_refine_agreement =
	{
		name = "Refine Agreement",
		cost = 0,
		desc = "Gain 10 shills.",
		flavour = "'There's always room to negotiate. That's the beauty of the contract.'",
		manual_desc = true,
		flags = CARD_FLAGS.DIPLOMACY | CARD_FLAGS.EXPEND,
		rarity = CARD_RARITY.UNIQUE,
		icon = "negotiation/observation.tex",
		min_persuasion = 0,
		max_persuasion = 4,
		money = 10,
		OnPostResolve = function( self )
            self.engine:ModifyMoney( self.money )
        end,
	},
	
	improvise_clear_violation =
	{
		name = "Clear Violation",
		cost = 0,
		desc = "Remove a random enemy argument. Gain Provoked equal to half its maximum resolve.",
		flavour = "'Yeah, Clauses 2, 37, and Turqouise-Alfa all mention that you can't do that.",
		manual_desc = true,
		flags = CARD_FLAGS.HOSTILE | CARD_FLAGS.EXPEND,
		rarity = CARD_RARITY.UNIQUE,
		icon = "negotiation/debate.tex",
		money_cost = 25,		
		
		target_enemy = TARGET_ANY_RESOLVE,

		CanTarget = function( self, target )
            if target and target.modifier_type == MODIFIER_TYPE.CORE then
                return false, CARD_PLAY_REASONS.INVALID_TARGET
            end
            return true
        end,
		
        OnPostResolve = function( self, minigame, targets )
            self.engine:ModifyMoney( self.money )
			for i,target in ipairs(targets) do
				local cur, max = target:GetResolve()
                    target.negotiator:RemoveModifier(target, target.stacks, self)
					self.negotiator:CreateModifier("PROVOKED", max, self)
                end
            end
	},
	
	improvise_reexamine =
	{
		name = "Re-examine",
		cost = 0,
		desc = "Gain 1 {PROVOKED}. Play {the_contract} again.",
		flavour = "'Yes, go over it again! You do not want to mess this up!",
		manual_desc = true,
		money_cost = 5,
		
		features =
			{
				PROVOKED = 1,
			},
		
		flags = CARD_FLAGS.MANIPULATE | CARD_FLAGS.EXPEND,
		rarity = CARD_RARITY.UNIQUE,
		icon = "negotiation/night_shift.tex",
		
		        OnPostResolve = function( self, minigame, target )
            local card = Negotiation.Card("the_contract", self.owner)
            card.show_dealt = false
            card.generation = (self.generation or 0) + 1
            card:SetFlags(CARD_FLAGS.EXPEND)
            minigame:DealCard(card, minigame:GetHandDeck())
            minigame:PlayCard(card)
        end,
	},
	
	improvise_corrections =
	{
		name = "Corrections",
		cost = 0,
		desc = "Spend 1 {PROVOKED}. Gain 2 {DOMINANCE}. Gain 5 shills.",
		flavour = "'Wrong, wrong, wrong! Is this the first time you've put pen to paper?'",
		manual_desc = true,
		money = 10,
		
		flags = CARD_FLAGS.HOSTILE | CARD_FLAGS.EXPEND,
		rarity = CARD_RARITY.UNIQUE,
		icon = "negotiation/abrupt_remark.tex",
		
		OnPostResolve = function( self, minigame )
            if self.negotiator:HasModifier("PROVOKED") then 
                if self.negotiator:GetModifierStacks("PROVOKED") >= 2 then
                    self.engine:ModifyMoney( self.money )
					self.negotiator:AddModifier( "DOMINANCE", 2, self)
                    self.negotiator:RemoveModifier("PROVOKED", 2)
                end
            end
        end,
	},
	
	improvise_financial_security =
	{
		name = "Financial Security",
		cost = 0,
		desc = "Apply 3 {COMPOSURE} to all friendly arguments.",
		flavour = "'Of course I won't act against you. If I was going to, why would I be giving you all this money?'",
		manual_desc = true,
		icon = "negotiation/empathy.tex",
		money_cost = 10,
		features =
			{
				COMPOSURE = 3,
			},
		rarity = CARD_RARITY.UNIQUE,
		flags = CARD_FLAGS.DIPLOMACY | CARD_FLAGS.EXPEND,
		target_mod = TARGET_MOD.TEAM,
		        target_self = TARGET_ANY_RESOLVE,
        auto_target = true,
	},
	
	laughing_taunt =
	{
		name = "Laughing Taunt",
		cost = 1,
		desc = "Consume all of your {PROVOKED} and gain {DOMINANCE} equal to that amount.",

		flags = CARD_FLAGS.MANIPULATE,
		rarity = CARD_RARITY.UNCOMMON,

		OnPostResolve = function( self, minigame )
			self.negotiator:AddModifier( "DOMINANCE", self.negotiator:GetModifierStacks("PROVOKED"), self)
			self.negotiator:RemoveModifier("PROVOKED", self.negotiator:GetModifierStacks("PROVOKED"))
        end,

	},
}

for i, id, carddef in sorted_pairs( CARDS ) do
	carddef.series = carddef.series or "LYRA"
    Content.AddNegotiationCard( id, carddef )
end

local MODIFIERS = 
{
	CONTRACTOR_MENTALITY =
    {
        name = "Contractor Mentality",
        desc = "When Lyra's core argument is attacked from any source, gain 1 Provoked.",

        modifier_type = MODIFIER_TYPE.CORE,
		icon = "negotiation/modifiers/deadline.tex",
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
        
		icon = "negotiation/modifiers/heated.tex",
        
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
