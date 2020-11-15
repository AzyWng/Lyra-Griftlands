local def = CharacterDef("PC_LYRA",
{
    base_def = "PLAYER_BASE",
    default_skin = "f5c5bf85-1e7b-4f40-9ab3-5794f4d37f0a",
	
    -- anims = { "anim/weapon_gunsha_powder_wealthy_merchant.zip","anim/weapon_spark_canister_wealthy_merchant.zip"},
    -- combat_anims = { "anim/med_combat_wealthy_merchant.zip" },
    anims = {"anim/weapon_knife_guard_lumin.zip"},
    combat_anims = { "anim/med_combat_knife_admiralty_clerk.zip" },	
	
    max_grafts = {
        [GRAFT_TYPE.COMBAT] = 4,
        [GRAFT_TYPE.NEGOTIATION] = 2,
        [GRAFT_TYPE.COIN] = 0,
    },

    max_resolve = 25,

    fight_data = 
    {
        MAX_HEALTH = 60,
        ranged_riposte = false,
        actions = 3,
        formation = FIGHTER_FORMATION.FRONT_X,
    },

    negotiation_data =
    {
        behaviour =
        {
            OnInit = function( self, difficulty )
                self.negotiator:AddModifier( "GRIFTER" )
            end,
        }
    },

    card_series = { "SAL", "GENERAL", "LYRA" },
    graft_series = { "SAL", "GENERAL", "LYRA" },

    hair_colour = 0xCB5D3Cff,
    skin_colour = 0xd2a18cff,
    text_colour = 0xd16160FF,
        
    faction_id = PLAYER_FACTION,
})
def:InheritBaseDef()

Content.AddCharacterDef( def )