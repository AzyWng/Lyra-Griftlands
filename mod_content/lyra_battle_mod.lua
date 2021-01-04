local battle_defs = require "battle/battle_defs"
local CARD_FLAGS = battle_defs.CARD_FLAGS
local EVENT = battle_defs.EVENT
local BATTLE_EVENT = battle_defs.BATTLE_EVENT
require "eventsystem"

local CARDS =
{
	lyra_wrench_swing =
	{
		name = "Wrench Swing",
		anim = "slice",
		rarity = CARD_RARITY.BASIC,
		flavour = "'The power to fix and destroy... the wrench is a strange tool indeed.'",
		
		icon = "battle/reckless_swing.tex",
		cost = 1,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 1,
		max_damage = 5,
	},
	
	lyra_wrench_swing_plus_mauled =
	{
		name = "Cruel Wrench Swing",
		desc = "Apply 2 {MAULED}.",
		OnPostResolve = function( self, battle, attack )
		attack:AddCondition("MAULED", 2, self)
		end
	},
	
	lyra_snap_shot =
	{
		name = "Snap Shot",
		anim = "shoot",
		rarity = CARD_RARITY.BASIC,
		flavour = "'Take the shot and keep moving.'",
		cost = 1,
		icon = "battle/rat_shot.tex",
		flags = CARD_FLAGS.PIERCING | CARD_FLAGS.RANGED,
		min_damage = 3,
		max_damage = 3,
	},
	
	lyra_violent_opportunism =
	{
		name = "Violent Opportunism",
		anim = "slice",
		rarity = CARD_RARITY.UNCOMMON,
		flavour = "'It doesn't have to hit hard - it just has to hit.'",
		desc = "Attack twice. If target has {MAULED}, hit four times.",

		icon = "battle/jab.tex",
		cost = 0,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 1,
		max_damage = 1,
		hit_count = 2,
		
		event_handlers =
		{
		 [ BATTLE_EVENT.CALC_HIT_COUNT ] = function( self, acc, card, target )
                if card == self and target and target:HasCondition("MAULED") then
					self.hit_count = 4
					else self.hit_count = 2
                end
            end
		}
	},
	
	lyra_wrench_rush =
	{
		name = "Wrench Rush",
		anim = "slice",
		rarity = CARD_RARITY.COMMON,
		desc = "Attack twice.",
		manual_desc = true,

		icon = "battle/bash.tex",
		flavour = "'Swing fast enough, and you can overwhelm your opponent.'",
		cost = 1,
		flags = CARD_FLAGS.MELEE,
		
		min_damage = 2,
		max_damage = 2,
		hit_count = 2,
	},
		lyra_wrench_rush_plus_damage =
	{
		name = "Boosted Wrench Rush",
		min_damage = 3,
		max_damage = 3,
	},
		lyra_wrench_rush_plus_hits =
	{
		desc = "Attack three times.",
		name = "Mirrored Wrench Rush",
		hit_count = 3,
	},
--		lyra_wrench_rush_plus_selfdestruct =
--	{
--		name = "Wrench Rush of Clarity",
--		desc = "<#UPGRADE>{CONSUME}</>",
--		manual_desc = true,
--		min_damage = 6,
--		max_damage = 8,
--		flags = CARD_FLAGS.MELEE | CARD_FLAGS.CONSUME
--	},
		-- lyra_wrench_rush_plus_scarred =
	-- {
		-- name = "Contractor's Wrench Rush",
		-- desc = "Gain 2 Scarred.",
		-- OnPostResolve = function( self, battle, attack )
		-- self.owner:AddCondition("SCARRED", 2, self)
		-- end
	-- },
	
			-- lyra_wrench_rush_plus_mauled =
	-- {
		-- name = "Cruel Wrench Rush",
		-- desc = "Apply 2 Mauled.",
			-- OnPostResolve = function( self, battle, attack )
			-- attack:AddCondition("MAULED", 2, self)
			-- end
	-- },
	
	-- Newly added. Dunno if this is done properly...
		lyra_warning_shot =
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
		lyra_warning_shot_plus_aoe =
	{
		name = "Wide Warning Shot",
		desc = "Inflict 2 Impair to <#UPGRADE>all enemies</>.",
		manual_desc = true,
		target_mod = TARGET_MOD.TEAM,
	},
		lyra_warning_shot_plus_anticipation =
	{
		name = "Anticipating Warning Shot",
		desc = "Inflict 2 Impair. <#UPGRADE>Gain 1 Anticipating.</>",
		OnPostResolve = function( self, battle )
			self.owner:AddCondition("ANTICIPATING", 1, self)
		end
	},
	
		lyra_contractors_fighting =
	{
		name = "Contractor's Fighting",
		anim = "taunt",
		desc = "{IMPROVISE} a card from a pool of special cards.",
		flavour = "'There's only one rule in combat: Come out on top.'",
        target_type = TARGET_TYPE.SELF,

        rarity = CARD_RARITY.BASIC,
        flags = CARD_FLAGS.SKILL,
        cost = 1,
        has_checked = false,

        pool_size = 3,

        pool_cards = {"lyra_improvise_caltrops",},

        OnPostResolve = function( self, battle, attack)
            local cards = ObtainWorkTable()

            cards = table.multipick( self.pool_cards, self.pool_size )
            for k,id in pairs(cards) do
                cards[k] = Battle.Card( id, self.owner  )
            end
            battle:ImproviseCards( cards, 1 )
            ReleaseWorkTable(cards)
        end,
    },
	
		lyra_improvise_caltrops =
	{
		name = "Caltrops",
		anim = "taunt",
		desc = "Gain 2 {RIPOSTE}.",
		cost = 0,
		rarity = CARD_RARITY.UNIQUE,
		flavour = "'Just make sure the bag you're storing 'em in is tough. And that you wear good gloves.'",
        features = 
        {
            RIPOSTE = 2,
        },
	},
	
		lyra_old_pain =
	{	
		name = "Old Pain",
		anim = "kick",
		rarity = CARD_RARITY.UNCOMMON,		
		desc = "Gain {SCARRED} equal to half damage dealt by this card.",
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
						self.owner:AddCondition("SCARRED", hit.damage/2 or 0, self)
					end
				end
		end
	},
	
		lyra_old_pain_plus_scarred =
	{
		name = "Fresh Pain",
		OnPostResolve = function( self, battle, attack, hit )
				for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						self.owner:AddCondition("SCARRED", hit.damage or 0, self)
					end
				end
		end
	},
		lyra_old_pain_plus_min_damage =
	{
		name = "Rooted Pain",
		min_damage = 4,
	},

		lyra_tear_flesh =
	{
		name = "Tear Flesh",
		rarity = CARD_RARITY.RARE,
		desc = "Deal 1 bonus damage for every {WOUND} the target has.",
		flavour = "'When she started making the wounds wider I had to look away...'",
		
		flags = CARD_FLAGS.MELEE | CARD_FLAGS.EXPEND,
		
		cost = 1,
		
		min_damage = 3,
		max_damage = 3,
		
		bonus_damage = 1,
		
		event_handlers =
        {
            [ BATTLE_EVENT.CALC_DAMAGE ] = function( self, card, target, dmgt )
                if card == self and target then
                    local wounding = target:GetConditionStacks("WOUND")
                    if wounding then
                        dmgt:AddDamage(self.bonus_damage * wounding, self.bonus_damage * wounding, self)
                    end
                end
            end,
        },
    },
	
		lyra_messy_harvest =
	{
		name = "Messy Harvest",
		rarity = CARD_RARITY.COMMON,
		anim = "trip",
		desc = "Heal 1 damage for every {WOUND} and {MAULED} the target has.",
		cost = 1,
		flavour = "'Is she trying to tear out his... oh Hesh, I think I'm gonna be sick.'",
		flags = CARD_FLAGS.MELEE | CARD_FLAGS.EXPEND,
		icon = "battle/ravenous.tex",
		
		apply = function( self, battle, target, stacks, attack )
			if not attack:CheckHitResult( target, "evaded" ) then
					if target:HasCondition("MAULED") or target:HasCondition("WOUND") then
						self.owner:HealHealth(target:GetConditionStacks("MAULED")+target:GetConditionStacks("WOUND"), self)
					end
                end
            end
	},	
	-- and inflict 1 point of {SURRENDER} 
-- hit.target:DeltaMorale( (wounding)+(maimed))	
	
	lyra_ending_swing =
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
	
	lyra_anticipating_blow =
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
	
	MAULED =
	{
		name = "Mauled",
		desc = "When this target is attacked, they receive 1 Wound and lose 1 <b>Mauled</b>.",
		ctype = CTYPE.DEBUFF,
        persist_on_death = true,
		
		icon = "battle/conditions/bloody_mess.tex",
		apply_sound = "event:/sfx/battle/status/system/Status_Buff_Attack_Wound",
        fx_sound = "event:/sfx/battle/status/system/Status_Buff_Attack_Wound_FX",
        fx_sound_delay = .3,
        apply_fx = { "wound"},
		
		target_type = TARGET_TYPE.ENEMY,
		
		event_handlers =
		{
			[ BATTLE_EVENT.ON_HIT ] = function( self, battle, attack, hit )
				if attack:IsTarget( self.owner ) and attack.card:IsAttackCard() then
					self.owner:AddCondition("WOUND", 1, self)
					self.owner:RemoveCondition("MAULED", 1, self)
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