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
S
        rarity = CARD_RARITY.UNIQUE,

        battle_condition = 
        {
			hidden = true,
			event_handlers =
            {
                [ BATTLE_EVENT.CONDITION_ADDED ] = function( self, fighter, condition, stacks, source )
                    if fighter == self.owner and condition.ctype == CTYPE.DEBUFF then
                        self.owner:ApplyDamage(2, self.owner, self)
                        self.battle:BroadcastEvent( BATTLE_EVENT.GRAFT_TRIGGERED, self.graft )
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
