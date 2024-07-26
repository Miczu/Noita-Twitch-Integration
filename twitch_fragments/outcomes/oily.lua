--Oiled up
--Leaking oil... can't be a good sign
--enviromental
--80
--todo
function twitch_oily()
	async(function()
		local x, y = get_player_pos()
		for i = 1, 50, 1 do
			x, y = get_player_pos()
			LoadPixelScene("mods/twitch-integration/files/pixel_scenes/oily.png","",x-45 , y-55, "", true)
			wait(rand(100,300))
		end
	end)
end
