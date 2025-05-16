--Swapper Curse
--I bet he's in a better position than me
--curses
--100
--Swaps with enemies in unpredictable manner
function twitch_swapper_curse()
	local name = "Swapper Curse"
	add_icon_effect("mods/twitch-integration/files/effects/status_icons/swapper.png", name, "You feel jealous of others position in life", 45*60, function()
		async(function()
			--GamePrint("Start")
			local lastSwap = GameGetFrameNum()
			repeat
				local pid = get_player()
				if pid ~= nil then
					local cid = EntityGetFirstComponent(pid, "ControlsComponent")
					local x, y = ComponentGetValue2(cid, "mMousePosition") -- 1280/720
					local r = (GameGetFrameNum()-lastSwap)/9;
					if (swap_if_possible(pid, "homing_target", x, y, r)) then
						wait(6 * 60)
						lastSwap = GameGetFrameNum()
					end
				end
				wait(1)
			until not is_icon_effect_active(name)
		end)
	end)
end

function swap_if_possible(id, tag, x, y, radius)
	local eid = EntityGetInRadiusWithTag( x, y, radius, tag )[1]
	if(eid and id) then
		local x, y = EntityGetTransform(id)
		local n, m = EntityGetTransform(eid)
		EntitySetTransform(id, n, m)
		EntitySetTransform(eid, x, y)
		return true;
	end
	return false
end
