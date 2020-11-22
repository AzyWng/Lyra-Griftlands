local def = CharacterDef("PC_LYRA",
{
    base_def = "PLAYER_BASE",
    name = "Lyra",
    alias = "LYRA",
    id = "PC_LYRA",
    title = "Contractor",

    -- default_skin = "f5c5bf85-1e7b-4f40-9ab3-5794f4d37f0a",
    anims = {"anim/weapon_club_promoted_spark_baron.zip"},
    combat_anims = { "anim/med_combat_club_promoted_spark_baron.zip" },

    head = "head_female_farmer_001",
    build = "female_tei_utaro_build",

    gender = GENDER.FEMALE,
	species = SPECIES.HUMAN,
	
    max_grafts = {
        [GRAFT_TYPE.COMBAT] = 4,
        [GRAFT_TYPE.NEGOTIATION] = 2,
        [GRAFT_TYPE.COIN] = 0,
    },

    max_resolve = 25,

    fight_data = 
    {
        MAX_HEALTH = 70,
        ranged_riposte = false,
        actions = 3,
        formation = FIGHTER_FORMATION.FRONT_X,
    },

    negotiation_data =
    {
        behaviour =
        {
            OnInit = function( self, difficulty )
                -- self.negotiator:AddModifier( "GRIFTER" )
                self.negotiator:AddModifier("CONTRACTOR_MENTALITY")
            end,
        }
    },

    card_series = { "GENERAL", "LYRA" },
    graft_series = { "GENERAL", "LYRA" },

    hair_colour = 0xCABFB1ff,
    skin_colour = 0xd2a18cff,
    text_colour = 0xd16160FF,
        
    faction_id = PLAYER_FACTION,
})
def:InheritBaseDef()

Content.AddCharacterDef( def )
