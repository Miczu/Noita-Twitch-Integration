--Linear Arc Shots
--Makes projectiles fire only in cardinal directions
--curses
--100
--Your projectiles only fire in cardinal directions
function twitch_spiritusigneus_line_arc_shot()
	local players = EntityGetWithTag("player_unit")
	for k=1,#players
	do v = players[k]
		local found = false
		local children = EntityGetAllChildren(v)
		for z=1,#children do
			if EntityGetName(children[z]) == "spiritusigneus_line_arc" then
				local comp = EntityGetFirstComponentIncludingDisabled(children[z],"GameEffectComponent")
				ComponentSetValue2(comp,"frames",ComponentGetValue2(comp,"frames") + 2700)
				found=true
				break
			end
		end
		if found == false then
			local x,y = EntityGetTransform(v)
			local c = EntityLoad("mods/twitch-integration/files/entities/misc/effect_line_arc_shot.xml",x,y)
			EntityAddChild(v,c)
		end
	end
end