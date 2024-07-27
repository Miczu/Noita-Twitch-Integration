--Bleeding
--I think you might need a bandage
--enviromental
--160
--todo
function twitch_bleeding()
	async(function()
		local x, y = get_player_pos()
		for i = 1, 50, 1 do
			x, y = get_player_pos()
			LoadPixelScene("mods/twitch-integration/files/pixel_scenes/bleeding.png","",x-7 , y-11, "", true)
			wait(rand(100,300))
		end
	end)
end
