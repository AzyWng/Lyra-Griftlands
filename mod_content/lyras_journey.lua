
AddPlayerCharacter(
    PlayerBackground{
            id = "LYRA",

            player_agent = "PC_LYRA",
            -- player_agent_skin = "f5c5bf85-1e7b-4f40-9ab3-5794f4d37f0a",

            head = "head_female_merc_02",
            build = "female_tei_utaro_build",

            name = "Lyra Concept",
            title = "The Contractor",
            desc = "A fish out of water, trying to make a bigger splash than the rest.",
            advancement = DEFAULT_ADVANCEMENT,

            -- vo = "event:/vo/narrator/character/sal",

            -- pre_battle_music = "event:/music/dailyrun_precombat_sal",
            -- deck_music = "event:/music/viewdecks_sal",
            -- boss_music = "event:/music/adaptive_battle_boss_rook",
            -- battle_music = "event:/music/adaptive_battle_rook",
            -- negotiation_music = "event:/music/adaptive_negotiation_barter_rook",

            -- ambush_neutral = "event:/music/stinger/ambush_neutral_rook",
            -- ambush_bad = "event:/music/stinger/ambush_bad_rook",
        }

        :AddAct{
            id = "LYRAS_ADVENTURE",
            
            name = "The Missing Tools",
            title = "Lyra In Murder Bay",
            desc = "Lyra settles scores, repays debts, and searches for a package.",
            
            act_image = engine.asset.Texture("UI/char_1_campaign.tex"),
            colour_frame = "0xFFDE5Aff",
            colour_text = "0xFFFF94ff",
            colour_background = "0xFFA32Aff",

            world_region = "murder_bay",

            max_resolve = 25,

            main_quest = "LYRAS_JOURNEY",
            game_type = GAME_TYPE.CAMPAIGN,

            -- slides = {
            --     "starting_sal_slideshow",
            --     "starting_sal_slideshow_2",
            --     "starting_sal_slideshow_3",
            --     "starting_sal_slideshow_4",
            -- },
            
            convo_filter_fn = function( convo_def, game_state )
                if convo_def.id == "REST_AND_RELAXATION" then
                    return false
                end

                return true
            end,

            starting_fn = function( agent, game_state) 
                agent:DeltaMoney( 0 )
            end,
        })


-- You can allow this act to be played by other player backgrounds by making a unique clone for that character.
--[[
local act = GetPlayerActData( "LYRAS_ADVENTURE" )
GetPlayerBackground( "ROOK" ):AddClonedAct( act, "ROOKS_ADVENTURE" )
--]]

--------------------------------------------------------------------------------

local decks = 
{
    NegotiationDeck("negotiation_basic", "PC_LYRA")
        :AddCards{ 
            lyra_professionalism = 3,
            lyra_aggression = 2,
            lyra_steadiness = 3,
			lyra_the_contract = 1,
        },
    
    BattleDeck("battle_basic", "PC_LYRA")
        :AddCards{ 
            lyra_wrench_swing = 3,
            feint = 3,
            lyra_contractors_fighting = 1,
			lyra_snap_shot = 1,
        },
}

for k,v in ipairs(decks) do
    Content.AddDeck(v)
end

