local filepath = require "util/filepath"

-- OnNewGame is called whenever a new game is started.
local function OnNewGame( mod, game_state )
    -- Require this Mod to be installed to launch this save game.
    if game_state:GetCurrentActID() == "LYRAS_JOURNEY" then
        game_state:RequireMod( mod )
    end
end

local function PostLoad( mod )
    print( "PostLoad", mod.id )
end


-- OnLoad is called on startup after all core game content is loaded.
local function OnLoad( mod )

    -- LOAD EVERYTHING
    for k, filepath in ipairs( filepath.list_files( "LYRASJOURNEY:mod_content", "*.lua", true )) do
        filepath = filepath:match( "^(.+)[.]lua$")
        require( filepath )
    end

    ------------------------------------------------------------------------------------------
    -- These additional names are available for randomly generated characters across all campaigns.

    ------------------------------------------------------------------------------------------
    -- Aspects

    ------------------------------------------------------------------------------------------
    -- Player backgrounds
    
    ------------------------------------------------------------------------------------------
    -- Factions

    ------------------------------------------------------------------------------------------
    -- Codex

    ------------------------------------------------------------------------------------------
    -- Cards / Grafts
	-- require "LYRASJOURNEY:mod_content/lyra_battle_mod"

    ------------------------------------------------------------------------------------------
    -- Characters

    ------------------------------------------------------------------------------------------
    -- Convos / Quests


    ------------------------------------------------------------------------------------------
    -- Locations

    return PostLoad
end

return
{
    -- [optional] version is a string specifying the major, minor, and patch version of this mod.
    version = "0.1.1",

    -- Pathnames to files within this mod can be resolved using this alias.
    alias = "LYRASJOURNEY",
    
    -- Mod API hooks.
    OnPreLoad = OnPreLoad,
    OnLoad = OnLoad,
    OnNewGame = OnNewGame,
    OnGameStart = OnGameStart,

    mod_options = MOD_OPTIONS,

    -- UI information about this mod.
    title = "Lyra's Journey",

    -- You can embed this mod's descriptive text directly...
    -- description = "Play as Shel and guide her to riches and discover the mysterious Lost Passage!",

    -- or look it up in an external file.
    description_file = "LYRASJOURNEY:about.txt",

    -- This preview image is uploaded if this mod is integrated with Steam Workshop.
    previewImagePath = "preview.png",
}
