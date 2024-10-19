--Curse of the Temple
--Don't die to the curse
--enviromental
--70
--todo
function twitch_green_crystal_trap()
	async(function()
		for i = 0, 15, 1 do
			async(function()
				local x, y = get_point_in_view_random_angle(65-i*8, 250-i*15, 20, true, -65+i*3)
				addCursePoints(x, y)
				local ent = EntityLoad("data/entities/particles/particle_explosion/main_swirly_green.xml", x, y)
				wait(10+i*3)
				local ent = EntityLoad("mods/twitch-integration/data/entities/crystal_green_effect.xml", x, y)
			end)
			wait(45-i)
		end
		wait(60*60)
		removeFirstCursePoints(15)
	end)
end

function get_point_in_view_random_angle(min_distance, max_distance, safety, inEmpty, under)
	safety = safety or 20
	if inEmpty ~= true then inEmpty = false end	
	
	local x, y, hit, hx, hy, angle
	repeat
		wait(1)
		local fraction = math.random();
		x, y = get_player_pos()
		hit, hx, hy, angle = Raycast(x, y, max_distance+10, fraction)
	until(hit == inEmpty and dist(x, y, hx, hy) > (min_distance*min_distance) and dist(x, y, hx, hy) < (max_distance*max_distance) and hy > y + under and not isCurseNearby(hx, hy, 42))
	
	return hx, hy
end

-- Create a table to store the collection of cursePoints
local cursePoints = {}

-- Function to add a new point {x, y} to the collection
function addCursePoints(x, y)
    table.insert(cursePoints, {x = x, y = y})
end

-- Function to check if any point is within a given squared distance from {x, y}
function isCurseNearby(x, y, dist)
    local distSquared = dist * dist
    for _, point in ipairs(cursePoints) do
        local dx = point.x - x
        local dy = point.y - y
        local distanceSquared = dx * dx + dy * dy
        
        if distanceSquared <= distSquared then
            return true
        end
    end
    return false
end

-- Function to clear the collection
function removeFirstCursePoints(number)
    local count = math.min(#cursePoints, number) -- Determine how many points can be removed
    for i = 1, count do
        table.remove(cursePoints, 1) -- Always remove the first point (index 1)
    end
end
