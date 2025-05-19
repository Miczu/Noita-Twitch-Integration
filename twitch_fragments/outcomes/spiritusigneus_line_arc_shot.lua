--Linear Arc Shots
--Makes projectiles fire only in cardinal directions
--curses
--100
--Your projectiles only fire in cardinal directions
function twitch_spiritusigneus_line_arc_shot()
    async(effect_spiritusigneus_line_arc_shot)
end

function effect_spiritusigneus_line_arc_shot()
    local player

    repeat
		wait(1);
		player = get_player_nopoly();
	until player > 0;

	local found = false
	local children = EntityGetAllChildren(player)
	for z=1,#children do
		if EntityGetName(children[z]) == "spiritusigneus_line_arc" then
			local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
			ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 2700)
			found=true
			break
		end
	end
	if found == false then
		local x,y = EntityGetTransform(player)
		local c = EntityLoad("mods/twitch-integration/files/entities/misc/effect_line_arc_shot.xml",x,y)
		EntityAddChild(player,c)
	end
end