--Glue Curse
--Whatever they are shooting, I need to avoid it
--curses
--100
--Enemy attacks will apply glue effect
function twitch_glue_curse()
	add_icon_effect("data/ui_gfx/gun_actions/glue_shot.png", "Glue Curse", "Don't meet a sticky end", 80*60, function()
		async(glueCurseMonitor)
	end)
end

function glueCurseMonitor()	
	local playerId;

	repeat
		wait(1);
		playerId = get_player();
	until playerId > 0;

	local compId = EntityAddComponent( playerId, "LuaComponent", 
	{
	  script_damage_received = "mods/twitch-integration/data/scripts/glue_curse.lua",
	  execute_every_n_frame = "-1"
	});
	
	repeat
		wait(1);
		playerId = get_player();
	until not is_icon_effect_active("Glue Curse") and playerId > 0;

	EntityRemoveComponent(playerId, compId);
end

