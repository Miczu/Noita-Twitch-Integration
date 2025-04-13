--Possess Wand
--Chat needs this for a bit
--bad_effects
--200
--
function twitch_conga_steal_wand()
    async(effect_conga_steal_wand)
end

function effect_conga_steal_wand()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

    local x,y = EntityGetTransform(player)
    local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_steal_wand.xml",x,y)
    EntityAddChild(player,c)
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create",x,y)
end

