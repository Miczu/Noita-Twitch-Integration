function TwitchChestLogic(x , y , entity_id , rng)
	
	local ukko = tonumber(GlobalsGetValue("twitch_ukko_in_box", "0"))
	
	if(ukko>0) then
		EntityLoad( "data/entities/animals/thundermage.xml", x + Random(-10,10), y - 4 + Random(-10,10) )
		GlobalsSetValue("twitch_ukko_in_box", tostring(ukko-1))
	end
	return rng
end

function TwitchChestKuuCheck(rng,x,y)
	local kuucount = tonumber(GlobalsGetValue("twitch_holiday_kuu", "0"))
    if kuucount > 0 then
        EntityLoad( "data/entities/items/pickup/moon.xml", x + Random(-10,10), y - 4 + Random(-5,5) )
        GlobalsSetValue("twitch_holiday_kuu", tostring(kuucount-1))
        return -1
    end
    return rng
end
