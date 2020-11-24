local battle_defs = require "battle/battle_defs"

local CARD_FLAGS = battle_defs.CARD_FLAGS
local BATTLE_EVENT = battle_defs.BATTLE_EVENT

--------------------------------------------------------------------

local BATTLE_GRAFTS =
{
    contractors_experience =
    {
        name = "Contractor's Experience",
        desc = "Each time you take damage from any source (even if it is blocked or evaded), gain one {SCARRED}.",
        img = engine.asset.Texture( "LYRASJOURNEY:textures/penetration_scanner.png", true ),

        rarity = CARD_RARITY.UNIQUE,

        battle_condition = 
        {
			hidden = true,
			event_handlers =
            {
                [ BATTLE_EVENT.ON_HIT ] = function( self, fighter, condition, stacks, source )
                    if target == self and damage > 0 then
                        self.owner:AddCondition("SCARRED", 1, self)
                    end
                end
            },
        },
    },
}


---------------------------------------------------------------------------------------------

for i, id, graft in sorted_pairs( BATTLE_GRAFTS ) do
    graft.card_defs = battle_defs
    graft.type = GRAFT_TYPE.COMBAT
    graft.series = graft.series or "SHEL"
    Content.AddGraft( id, graft )
end
