--Tripping Balls
--Your reality has beeen balled
--bad_effects
--210
--todo
function twitch_shift()
    local player = get_player()
    local fungi = CellFactory_GetType("fungi")
    local frame = GameGetFrameNum()
	local last_frame = tonumber( GlobalsGetValue( "fungal_shift_last_frame", "-1000000" ) )
	if frame < last_frame + 60*60*5 and not debug_no_limits then
		return -- long cooldown
	end
    EntityIngestMaterial( player, fungi, 600 )
    empty_player_stomach()
	async(shift_warning)
end

function shift_warning()
	wait(10*60-70)
    local player = get_player()
	local x,y = EntityGetTransform(player)
	local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_standard_warning.xml",x,y)
	EntityAddChild(player,c)
	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/blindness/create",x,y)
end