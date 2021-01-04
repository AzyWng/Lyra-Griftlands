local battle_defs = require "battle/battle_defs"
local CARD_FLAGS = battle_defs.CARD_FLAGS
local EVENT = battle_defs.EVENT
local BATTLE_EVENT = battle_defs.BATTLE_EVENT
require "eventsystem"

local CARDS =
{
	swing =
	{
		name = "Swing",
		anim = "slice",
		rarity = CARD_RARITY.BASIC,
		
		icon = "battle/reckless_swing.tex",
		cost = 1,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 3,
		max_damage = 3,
		hit_count = 1,
	},
	wrench_rush =
	{
		name = "Wrench Rush",
		anim = "slice",
		rarity = CARD_RARITY.COMMON,
		desc = "Hits 2 times.",
		manual_desc = true,

		icon = "battle/bash.tex",
		flavour = "'Swing fast enough, and you can overwhelm your opponent.'",
		cost = 1,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 3,
		max_damage = 3,
		hit_count = 2,
	},
--		wrench_rush_plus_damage =
--	{
--		name = "Boosted Wrench Rush",
--		min_damage = 4,
--		max_damage = 4,
--	},
		wrench_rush_plus_hits =
	{
		desc = "Hits <#UPGRADE>{3}</> times.",
		name = "Mirrored Wrench Rush",
		hit_count = 3,
	},
--		wrench_rush_plus_selfdestruct =
--	{
--		name = "Wrench Rush of Clarity",
--		desc = "<#UPGRADE>{CONSUME}</>",
--		manual_desc = true,
--		min_damage = 6,
--		max_damage = 8,
--		flags = CARD_FLAGS.MELEE | CARD_FLAGS.CONSUME
--	},
		wrench_rush_plus_scarred =
	{
		name = "Contractor's Wrench Rush",
		OnPostResolve = function( self, battle, attack )
		self.owner:AddCondition("SCARRED", 2, self)
		end
	},
	-- Newly added. Dunno if this is done properly...
		warning_shot =
	{
		name = "Warning Shot",
		anim = "laser",
		rarity = CARD_RARITY.BASIC,
		desc = "Inflict 2 Impair.",
		manual_desc = true,
		icon = "battle/aerostat_coilgun.tex",
		flavour = "'The next one's in your head!'",
		cost = 1,
		flags = CARD_FLAGS.RANGED,
		features =
		{
			IMPAIR = 2,
		}
	},
		warning_shot_plus_aoe =
	{
		name = "Wide Warning Shot",
		desc = "Inflict 2 Impair to <#UPGRADE>all enemies</>.",
		manual_desc = true,
		target_mod = TARGET_MOD.TEAM,
	},
		warning_shot_plus_anticipation =
	{
		name = "Anticipating Warning Shot",
		desc = "Inflict 2 Impair. <#UPGRADE>Gain 1 Anticipating.</>",
		features =
		{
		IMPAIR = 2,
		},
		OnPostResolve = function( self, battle )
			self.owner:AddCondition("ANTICIPATING", 1, self)
		end
	},
		old_pain =
	{	
		name = "Old Pain",
		anim = "kick",
		rarity = CARD_RARITY.COMMON,		
		desc = "Gain {SCARRED} equal to damage dealt by this card.",
		manual_desc = true,
		icon = "battle/weakness_old_injury.tex",
		flavour = "'It's familiar. I can use it.'",
		cost = 1,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 2,
		max_damage = 4,
		hit_count = 1,
		
		OnPostResolve = function( self, battle, attack, hit )
                for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						self.owner:AddCondition("SCARRED", hit.damage or 0, self)
					end
				end
		end
	},
	ending_swing =
    {
		name = "Ending Swing",
		desc = "Spend all {SCARRED}. Heal 1 and deal 2 bonus damage per {SCARRED}.",
		anim = "uppercut",
		icon = "battle/the_sledge.tex",
		
		flags = CARD_FLAGS.MELEE,
        rarity = CARD_RARITY.UNCOMMON,
		cost = 1,
		
        min_damage = 3,
        max_damage = 6,
        
        bonus_damage = 2,

        OnPostResolve = function ( self, battle, attack)
            if self.owner:HasCondition("SCARRED") then
                self.owner:HealHealth(self.owner:GetConditionStacks("SCARRED"), self)
                self.owner:RemoveCondition("SCARRED", self.owner:GetConditionStacks("SCARRED"))
            end
        end,

        event_handlers =
        {
            [ BATTLE_EVENT.CALC_DAMAGE ] = function( self, card, target, dmgt )
                if self == card then
                    local scarred = self.owner:GetConditionStacks( "SCARRED" )
                    dmgt:AddDamage( self.bonus_damage * scarred, self.bonus_damage * scarred, self )
                end
            end
        },
	},
	
	anticipating_blow =
    {
		name = "Anticipating Blow",
		desc = "Gain {ANTICIPATING}.",
		anim = "uppercut",
		icon = "battle/stringer.tex",
		
        rarity = CARD_RARITY.UNCOMMON,
		flags = CARD_FLAGS.MELEE,
		cost = 1,
		
        min_damage = 3,
        max_damage = 6,
        
        OnPostResolve = function ( self, battle, attack)
            self.owner:AddCondition("ANTICIPATING", 1, self)
        end,
	},
}

for i, id, carddef in sorted_pairs( CARDS ) do
    carddef.series = carddef.series or "LYRA"
    Content.AddBattleCard( id, carddef )
end



local CONDITIONS =
{
    SCARRED = 
    {
        name = "Scarred",
        desc = "Used to activate certain effects. Upon the end of a battle, restore 1 point of health for each point of Scarred.",
        icon = "battle/conditions/wound.tex",
        ctype = CTYPE.BUFF,
        apply_sound = "event:/sfx/battle/status/system/Status_Buff_Attack_Combo",
		
        event_handlers =
        {
            [ EVENT.END_COMBAT ] = function( self, fighter )
				self.owner:HealHealth(self.owner:GetConditionStacks("SCARRED"), self)
				self.owner:RemoveCondition("SCARRED", self.owner:GetConditionStacks("SCARRED"), self)
            end,
        }
    },
	
	ANTICIPATING =
    {
        name = "Anticipating",
        desc = "Incoming attacks deal 50% less damage and remove 1 point of Anticipating. Everytime an {ANTICIPATING} stack is removed, gain a buff.",
        icon = "battle/conditions/evasion.tex",
        ctype = CTYPE.BUFF,
        apply_sound = "event:/sfx/battle/status/system/Status_Buff_Defend",
    
        damage_mult = .5,

            event_handlers =
            {
                [ BATTLE_EVENT.ON_HIT ] = function( self, battle, attack, hit )
                    if attack:IsTarget( self.owner ) and attack.card:IsAttackCard() then
                        if self.owner:HasCondition("ANTICIPATING") then
                            -- remove anticipating after being attacked
                            self.owner:RemoveCondition("ANTICIPATING", 1, self)

                            -- add buffs after removing anticipating
                            self.owner:AddCondition("POWER", 1, self)
                            self.owner:AddCondition("RIPOSTE", 1, self)
							-- self.owner:AddCondition("ANTICIPATINGFOLLOWUP", 1, self)
                        end
                    end
                end,
                [ BATTLE_EVENT.CALC_DAMAGE ] = function( self, card, target, dmgt )
                if target == self.owner then
                    dmgt:ModifyDamage( math.round( dmgt.min_damage * self.damage_mult ),
                                       math.round( dmgt.max_damage * self.damage_mult ),
                                       self )
                end
            end
			},
	},

	CONTRACTORS_EXPERIENCE =
    {
        name = "Contractor's Experience",
        desc = "Each time you take damage, gain one {SCARRED}.",
		icon = "battle/conditions/spree_rage.tex",
       
        event_handlers =
        {
			[ BATTLE_EVENT.ON_HIT ] = function( self, battle, attack, hit )
				if attack:IsTarget( self.owner ) and attack.card:IsAttackCard() then
					self.owner:AddCondition("SCARRED", 1, self)
				end
            end
        },
    },
	
	CONTRACTORS_EXPERIENCE =
    {
        name = "Contractor's Experience",
        desc = "Each time you take damage, gain one {SCARRED}.",
        icon = "battle/conditions/evasion.tex",

        event_handlers =
        {
            [ BATTLE_EVENT.ON_HIT ] = function( self, battle, attack, hit )
                if attack:IsTarget( self.owner ) and attack.card:IsAttackCard() then
                    self.owner:AddCondition("SCARRED", 1, self)
                end
            end
        },
    },
	
	-- ANTICIPATINGFOLLOWUP =
	-- {
	-- 	name = "(Anticipating) Follow Up",
	-- 	desc = "Gained whenever Anticipating is spent. Used to activate some effects. Removed at the end of your turn.",
	-- 	icon = "battle/conditions/follow_through.tex",
	-- 	ctype = CTYPE.BUFF,
	-- 	apply_sound = "event:/sfx/battle/status/system/Status_Buff_Defend",
	-- 	max_stacks = 99,
		
	-- 	event_handlers =
	-- 	{
	-- 		[ BATTLE_EVENT.END_TURN ] = function ( self, fighter )
	-- 			if fighter == self.owner then
	-- 				self.owner:RemoveCondition( self.id, )
	-- 			end
	-- 		end
	-- 	}
	-- },
}

for id, def in pairs( CONDITIONS ) do
    Content.AddBattleCondition( id, def )
end