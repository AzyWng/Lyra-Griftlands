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
		
		min_damage = 2,
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
	
	lyra_wrench_swing_plus_min_damage =
	{
		name = "Rooted Wrench Swing",
		min_damage = 4,
	},
	
	lyra_wrench_swing_plus_destroy =
	{
		name = "Clarity Wrench Swing",
		min_damage = 8,
		max_damage = 8,
		flags = CARD_FLAGS.MELEE | CARD_FLAGS.CONSUME,
	},
	
	lyra_wrench_swing_plus_expend =
	{
		name = "Lucid Wrench Swing",
		min_damage = 5,
		max_damage = 7,
		flags = CARD_FLAGS.MELEE | CARD_FLAGS.EXPEND,
	},
	
	lyra_wrench_swing_plus_scarred =
	{
		name = "Contractor's Wrench Swing",
		OnPostResolve = function( self, battle, attack, hit )
                for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						self.owner:AddCondition("SCARRED", 2 or 0, self)
					end
				end
		end
	},
	
	lyra_wrench_swing_plus_draw_card =
	{
		name = "Wrench Swing of Vision",
		
		OnPostResolve = function( self, battle, attack)
            battle:DrawCards( 1 )
        end,
	},
	
	lyra_wrench_swing_plus_defense =
	{
		name = "Stone Wrench Swing",

        features =
        {        
            DEFEND = 2,
        },
	},
	
	lyra_wrench_swing_plus_multihit =
	{
		name = "Mirrored Wrench Swing",
		max_damage = 4,
		
		hit_count = 2,
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
	
	-- lyra_snap_shot_plus_maimed =
	-- {
	
	-- lyra_violent_opportunism =
	-- {
		-- name = "Violent Opportunism",
		-- anim = "slice",
		-- rarity = CARD_RARITY.UNCOMMON,
		-- flavour = "'It doesn't have to hit hard - it just has to hit.'",
		-- desc = "Attack twice. If target has {MAULED}, insert 2 {lyra_violent_opportunism_followup} {2*card|cards} into your hand.",

		-- icon = "battle/jab.tex",
		-- cost = 0,
		-- flags = CARD_FLAGS.MELEE,
		
		-- min_damage = 1,
		-- max_damage = 1,
		-- hit_count = 2,
		-- num_cards = 2,

		-- OnPostResolve = function( self, battle, attack )
			-- if card == self and target and target:HasCondition("MAULED") then
			-- local cards = {}
            -- for i = 1, self.num_cards do
                -- local incepted_card = Battle.Card( "blade_flash", self:GetOwner() )
                -- table.insert( cards, incepted_card )
			-- end
            -- battle:DealCards( cards, battle:GetHandDeck() )
		-- end,
	-- },
	
	-- lyra_violent_opportunism_followup =
	-- {
		-- name = "Violent Followup",
		-- anim = "attack1",
		-- rarity = CARD_RARITY.UNIQUE,
		-- flavour = "Now's your chance.",
		-- desc = "Can only target enemies that have {MAULED}.",
		-- icon = "battle/jab.tex",
		-- cost = 0,
		-- flags = CARD_FLAGS.MELEE | CARD_FLAGS.EXPEND,
		-- min_damage = 1,
		-- max_damage = 1,
		-- hit_count = 2,
		
		-- loc_strings =
		-- {
			-- HAS_NO_MAULED = "Target has no Mauled",
		-- },
		
        -- CanPlayCard = function( self, battle, target )
            -- if target and not target:HasCondition("MAULED") then
                -- return false, self.def:GetLocalizedString("HAS_NO_MAULED")
            -- end
            -- return true
        -- end,
	
	lyra_endurance =
	{
		name = "Endurance",
		anim = "taunt",
		rarity = CARD_RARITY.BASIC,
		desc = "Apply {1} {DEFEND}.",
		flavour = "'You've survived worse. Much worse.'",
        target_type = TARGET_TYPE.FRIENDLY_OR_SELF,
        cost = 1,
        max_xp = 6,
        flags = CARD_FLAGS.SKILL,
        wild = true,
        defend_amount = 3,

        OnPostResolve = function( self, battle, attack )
            attack:AddCondition( "DEFEND", self.defend_amount, self )
        end
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

        pool_cards = {"lyra_improvise_caltrops", "lyra_improvise_smoke_bomb", "lyra_improvise_takedown",},

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
		desc = "Gain {2} {DEFEND}. Gain 2 {RIPOSTE}.",
		cost = 0,
		rarity = CARD_RARITY.UNIQUE,
		flavour = "'Just make sure the bag you're storing 'em in is tough. And that you wear good gloves.'",
        features = 
        {
            RIPOSTE = 2,
        },
        defend_amount = 2,

        OnPostResolve = function( self, battle, attack )
            attack:AddCondition( "DEFEND", self.defend_amount, self )
        end
	},
	
		lyra_improvise_smoke_bomb =
	{
		name = "Smoke Bomb",
		anim = "taunt",
		desc = "Gain 2 {ANTICIPATING}.",
		icon = "battle/throw_dust.tex",
		cost = 0,
		rarity = CARD_RARITY.UNIQUE,
		flavour = "'Always have one of these handy. Pocket sand is for rookies.'",
		OnPostResolve = function( self, battle )
			self.owner:AddCondition("ANTICIPATING", 1, self)
		end
	},
	
		lyra_improvise_takedown =
	{
		name = "Takedown",
		anim = "attack1",
		desc = "Apply 2 {MAIMED}.",
		icon = "battle/tackle.tex",
		cost = 0,
		rarity = CARD_RARITY.UNIQUE,
		flavour = "'Get 'em on the ground, and they'll still be reeling for a few moments.'",

				OnPostResolve = function( self, battle, attack, hit )
                for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						attack:AddCondition("MAIMED", 2, self)
					end
				end
		end
	},
	
		lyra_improvise_throw_wrench =
	{
		name = "Throw Wrench",
		anim = "Attack1",
		desc = "Apply 2 {MAULED}.",
		icon = "battle/force_wrench.tex",
		cost = 0,
		rarity = CARD_RARITY.UNIQUE,
		flavour = "'Enough strength and it may as well be a javelin you're throwing.'",
				OnPostResolve = function( self, battle, attack, hit )
                for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						attack:AddCondition("MAULED", 2, self)
					end
				end
		end
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
		desc = "Gain {SCARRED} equal to damage dealt by this card.",
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
		
		min_damage = 4,
		max_damage = 4,
		
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
	
	lyra_schadenfreude =
	{
		name = "Schadenfreude",
		rarity = CARD_RARITY.COMMON,
		anim = "trip",
		desc = "Heal 1 damage for every {WOUND} and {MAULED} the target has.",
		cost = 1,
		flavour = "Eventually, you start to enjoy what you do to other people.",
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
	
	lyra_automatic_rifle =
	{
		name = "Lyra's Auto Rifle",
		rarity = CARD_RARITY.UNIQUE,
		anim = "shoot",
		desc = "Insert {lyra_full_auto} or {lyra_fuller_auto} into your hand.",
		flavour = "Most folk prefer to swap from gun to gun, but full-auto can have its uses.",
		flags = CARD_FLAGS.SKILL | CARD_FLAGS.EXPEND,
		cost = 1,
		target_mod = TARGET_MOD.TEAM,
		
        OnPostResolve = function( self, battle, attack)
            local cards = {
                Battle.Card( "lyra_full_auto", self.owner ),
                Battle.Card( "lyra_fuller_auto", self.owner ),
            }
            battle:ChooseCardsForHand( cards )
        end,
	},
	
	lyra_full_auto =
	{
		name = "Full Auto",
		rarity = CARD_RARITY.UNIQUE,
		anim = "shoot",
		desc = "Attack 3 times.",
		flavour = "Efficient. Also helps save on ammo.",
		flags = CARD_FLAGS.RANGED | CARD_FLAGS.PIERCING | CARD_FLAGS.EXPEND,
		cost = 0,
		min_damage = 3,
		max_damage = 3,
		hit_count = 3,
	},
	
	lyra_fuller_auto =
	{
		name = "Fuller Auto",
		rarity = CARD_RARITY.UNIQUE,
		anim = "shoot",
		desc = "Attack 6 times.",
		flavour = "For when you really need to bring the pain. Just don't drop it.",
		flags = CARD_FLAGS.RANGED | CARD_FLAGS.PIERCING | CARD_FLAGS.EXPEND,
		cost = 0,
		min_damage = 2,
		max_damage = 2,
		hit_count = 6,
		features =
		{
			EXERT = 1,
		},
	},
	
	lyra_pistols =
	{
		name = "Lyra's Pistols",
		rarity = CARD_RARITY.UNIQUE,
		anim = "taunt",
		desc = "Discard any number of cards, then fill your hand with {lyra_pistol_shot}.",
		flavour = "Cheap, light, and readily available, as is the ammunition. Why carry one when you can carry ten?",
		flags = CARD_FLAGS.SKILL | CARD_FLAGS.EXPEND,
		cost = 1,
		target_mod = TARGET_MOD.TEAM,
		
        OnPostResolve = function( self, battle, attack )
			local cards = {}
			battle:DiscardCards()
            local count = battle:GetHandDeck():GetMaxSize() - battle:GetHandDeck():CountCards()
            for i = 1, count do
                local card = Battle.Card( "lyra_pistol_shot", self.owner )
                if self.upgraded then
                    card:UpgradeCard()
                end
                card:SetFlags( CARD_FLAGS.FREEBIE )
                card:ClearXP()
                card:MakeTemporary()
                table.insert( cards, card )
            end
            battle:DealCards( cards, battle:GetHandDeck() )
        end,
	},
	
	lyra_pistol_shot =
	{
		name = "Pistol Shot",
		rarity = CARD_RARITY.UNIQUE,
		anim = "shoot",
		flavour = "'Shoot and drop it. The time between shots is too long to do anything more.'",
		flags = CARD_FLAGS.RANGED | CARD_FLAGS.EXPEND,
		cost = 0,
		
		min_damage = 1,
		max_damage = 1,
	},
	
	lyra_rapid_tossing =
	{
		name = "Rapid Tossing",
		rarity = CARD_RARITY.UNCOMMON,
		anim = "taunt",
		desc = "Ability: When you {DISCARD} or {EXPEND} a card, apply 1 {TRAUMA} to a random enemy.",
		icon = "battle/right_in_the_face.tex",
		flavour = "'When you're done with something, be sure to toss it in your target's face. It's only polite!'",
		flags = CARD_FLAGS.SKILL | CARD_FLAGS.EXPEND,
		cost = 2,
		target_type = TARGET_TYPE.SELF,
		
        OnPostResolve = function( self, battle, attack)
            local con = self.owner:AddCondition( "lyra_rapid_tossing", 1, self )
				if con then
					con.ignore_card = self
					end
				end,
		
		condition =
		{   
			desc = "Whenever you discard or expend a card, apply {1} {TRAUMA} to a random enemy.",
            desc_fn = function( self, fmt_str )
                return loc.format(fmt_str, self.trauma_amt * self.stacks)
            end,

            trauma_amt = 1,
		
			Trigger = function( self, battle )
                local target_fighters = {}
                battle:CollectRandomTargets( target_fighters, self.owner:GetEnemyTeam().fighters, 1 )

                for i=1, #target_fighters do
                    hit.target:AddCondition("TRAUMA", self.trauma_amt, self)
                end
            end,

            event_handlers =
            {
                [ BATTLE_EVENT.CARD_DISCARDED ] = function( self, card, battle )
                    self:Trigger( battle )
                end,
				
				[ BATTLE_EVENT.CARD_EXPENDED ] = function( self, card, battle )
                if card ~= self.ignore_card then
					self:Trigger( battle )
					end
				end,
            },
        },
	},
	
	-- and inflict 1 point of {SURRENDER} 
-- hit.target:DeltaMorale( (wounding)+(maimed))	
	
	lyra_eye_gouge =
	{
		name = "Eye Gouge",
		desc = "Spend 2 {SCARRED}: Apply 2 {IMPAIR}.",
		anim = "attack",
		icon = "battle/blasted_eye.tex",
		flavour = "'You don't wanna see what's next.'",
		flags = CARD_FLAGS.MELEE,
		rarity = CARD_RARITY.COMMON,
		cost = 1,
	
		min_damage = 2,
		max_damage = 5,
		
		impair_amount = 2,
		
		PreReq = function( self, battle )
			return self.owner:GetConditionStacks("SCARRED") >= 2
		end,
		
		OnPostResolve = function( self, battle, attack )
			if self.owner:GetConditionStacks("SCARRED") >= 2 then
				for i, hit in attack:Hits() do
					if not hit.evaded then
						self.owner:RemoveCondition("SCARRED", 2, self)
							hit.target:AddCondition("IMPAIR", self.impair_amount, self)
							end
						end
					end
				end
	},
	
	lyra_your_every_move =
	{
		name = "Your Every Move",
		desc = "Gain {ANTICIPATING} equal to damage dealt.",
		flavour = "'I bet I even know what you'd do once this is over. You won't be doing it, obviously, but still...'",
		anim = "attack1",
		icon = "battle/phantom_finisher.tex",
		flags = CARD_FLAGS.MELEE,
		rarity = CARD_FLAGS.RARE | CARD_FLAGS.EXPEND,
		
		cost = 2,
		
		min_damage = 2,
		max_damage = 4,

		OnPostResolve = function( self, battle, attack, hit )
				for i, hit in attack:Hits() do
					if not attack:CheckHitResult( hit.target, "evaded" ) then
						self.owner:AddCondition("ANTICIPATING", hit.damage or 0, self)
					end
				end
		end
	},
	
	lyra_ending_swing =
    {
		name = "Ending Swing",
		desc = "Spend all {SCARRED}. Heal 1 and deal 2 bonus damage per {SCARRED}.",
		flavour = "'This is what it's been building up to.'",
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
	
	lyra_strength_from_scars =
	{
		name = "Strength From Scars",
		desc = "Spend all {SCARRED}: Heal 2 for every {SCARRED} spent, gain 1 {POWER} for every {SCARRED} spent.",
		anim = "taunt",
		icon = "battle/battle_scars.tex",
		flavour = "The pain can make you stronger if you just accept it.",
		rarity = CARD_RARITY.RARE,
		flags = CARD_FLAGS.EXPEND,
		cost = 3
		
        OnPostResolve = function ( self, battle, attack)
            if self.owner:HasCondition("SCARRED") then
                self.owner:HealHealth(self.owner:GetConditionStacks("SCARRED")*2, self)
				self.owner:AddCondition("POWER", self.owner:GetConditionStacks("SCARRED")/3, self)
                self.owner:RemoveCondition("SCARRED", self.owner:GetConditionStacks("SCARRED"))
            end
        end,
	},
	
	lyra_anticipating_blow =
    {
		name = "Anticipating Blow",
		desc = "Gain {ANTICIPATING}.",
		anim = "uppercut",
		icon = "battle/stringer.tex",
		flavour = "'Even when you attack, you've gotta keep an eye out for the enemy's moves.'",
		
        rarity = CARD_RARITY.UNCOMMON,
		flags = CARD_FLAGS.MELEE,
		cost = 1,
		
        min_damage = 3,
        max_damage = 6,
        
        OnPostResolve = function ( self, battle, attack)
            self.owner:AddCondition("ANTICIPATING", 1, self)
        end,
	},
	
	lyra_lash_out =
	{
		name = "Lash Out",
		desc = "Gain 2 {DEFENSE} and {2} {RIPOSTE} for each {SCARRED} you have.",
		anim = "taunt",
		icon = "battle/wounding_barbs.tex",
		flavour = "'If hurting people is wrong, why does it make me feel so much better?'",
		rarity = CARD_RARITY.COMMON,
		flags = CARD_FLAGS.EXPEND,
		cost = 1,
		
		OnPostResolve = function ( self, battle, attack)
            if self.owner:HasCondition("SCARRED") then
			local scarred = self.owner:GetConditionStack( "SCARRED" )
                self.owner:AddCondition("RIPOSTE", scarred*2, self)
				self.owner:AddCondition("DEFEND", scarred*2, self)
            end
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
        desc = "Incoming attacks deal 50% less damage and remove 1 point of Anticipating.",
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
                            --self.owner:AddCondition("POWER", 1, self)
                            --self.owner:AddCondition("RIPOSTE", 1, self)
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
	
	    MAIMED =
    {
        name = "Maimed",
        feature_desc = "Gain {1} {MAIMED}.",
		desc = "Attack damage is decreased by {1}.",
        desc_fn = function( self, fmt_str, battle )
            return loc.format(fmt_str, self.stacks )
        end,
		
		apply_sound = "event:/sfx/battle/status/system/Status_Debuff_Fatigue",
		icon = "battle/conditions/lumin_daze.tex",
        fx_sound = "event:/sfx/battle/status/system/Status_Debuff_Fatigue",
        fx_sound_delay = .4,
        apply_fx = {"power"},

        ctype = CTYPE.DEBUFF,
		target_type = TARGET_TYPE.SELF,
        
		max_stacks = 99,
        min_stacks = -99,

        event_handlers =
        {
            [ BATTLE_EVENT.CALC_DAMAGE ] = function( self, card, target, dmgt )
                if card.owner == self.owner and card:IsAttackCard() then
                    dmgt:ModifyDamage( dmgt.min_damage - self.stacks, dmgt.max_damage - self.stacks, self )
                end
            end,
            [ BATTLE_EVENT.BEGIN_TURN ] = function( self, fighter )
                if self.owner == fighter then
                    self.owner:RemoveCondition("MAIMED", 1)
                end
            end
        }
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

local FEATURES =
{
	SCARRED = 
    {
        name = "Scarred",
        desc = "Used to activate certain effects. Upon the end of a battle, restore 1 point of health for each point of Scarred.",
	},

	    MAIMED =
    {
        name = "Maimed",
		desc = "Attack damage is decreased by 1 per stack. 1 stack is removed each turn.",
	},
		MAULED =
	{
		name = "Mauled",
		desc = "When this target is attacked, they receive 1 Wound and lose 1 <b>Mauled</b>.",
	},
	
		ANTICIPATING =
    {
        name = "Anticipating",
        desc = "Incoming attacks deal 50% less damage and remove 1 point of Anticipating.",
	},
	
},

for id, def in pairs( CONDITIONS ) do
    Content.AddBattleCondition( id, def )
end