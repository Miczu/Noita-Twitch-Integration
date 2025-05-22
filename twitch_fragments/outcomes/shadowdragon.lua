--Shadowdragon
--Wait what!?!
--worms
--45
--todo
function twitch_shadowdragon()
	async(shadowDragonAdd)
end

function shadowDragonAdd()	
	local playerId;

	repeat
		wait(1);
		playerId = get_player();
	until playerId > 0;

	local compId = EntityAddComponent( playerId, "LuaComponent", 
	{
	  script_damage_received = "mods/twitch-integration/data/scripts/shadow_dragon.lua",
	  execute_every_n_frame = "-1"
	});
	
	local pos_x, pos_y = EntityGetTransform( playerId )
    local dragon = EntityLoad("data/entities/animals/boss_dragon.xml", pos_x + 200, pos_y - 200);	
	local luaId = EntityAddComponent( dragon, "LuaComponent", 
	{
	  script_death = "data/scripts/animals/boss_dragon_death.lua",
	  execute_every_n_frame = "-1"
	});
	GlobalsSetValue( "ShadowDragonMonitor"..dragon, luaId )
	
	local boss = EntityGetFirstComponent( dragon, "BossDragonComponent")
	ComponentSetValue2( boss, "bite_damage", 0.16 ) -- down from 2 ... that is 2 * 25 in game LUL
	ComponentSetValue2( boss, "speed", 2 ) -- down from 3
	ComponentSetValue2( boss, "speed_hunt", 3 ) -- down from 4

	local damagemodel = EntityGetFirstComponent(playerId, "DamageModelComponent")
	local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))

	GlobalsSetValue( "ShadowDragon"..dragon, tostring(max_hp/4) )
end

