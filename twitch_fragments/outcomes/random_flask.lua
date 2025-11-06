--Random Flask
--What's in it?
--unknown
--180
--todo
function twitch_random_flask()
    local potion_material = ""
    if (Random(0, 100) <= 75) then
        if (Random(0, 100000) <= 50) then
            potion_material = "magic_liquid_hp_regeneration"
        elseif (Random(0, 100000) <= 250) then
            potion_material = "monster_powder_test"
        else
            potion_material = random_from_array(potion_materials_magic)
        end
    else
        potion_material = random_from_array(potion_materials_standard)
    end
    local x, y = get_player_pos()
    local sx,sy = nil,nil
    -- pick a random angle and increase it until we find a valid spawn
    local startAngle = Random() * math.pi * 2
    local angleAttempts = 360
    local radiusAttempts = 10
    local found = false
    for i = 0, angleAttempts do
        local angle = Random(0,360)*math.pi/180
        for j=1,radiusAttempts do
            local radius =Random(80,160)
            local tempSx,tempSy = x +radius*math.cos(angle), y +radius*math.sin(angle)
            if not thiccRaytrace(tempSx,tempSy,x,y-2,10) then
                sx,sy = tempSx, tempSy
                found = true
                break
            end
        end
        if found then
            break
        end
    end
    local failed = false
    if sx == nil then -- revert to old spawn method
        sx = x
        sy = y - 80
        failed = true
    end
    
    local entity = EntityLoad("data/entities/items/pickup/twitch_flask.xml", sx, sy)
    AddMaterialInventoryMaterial(entity, potion_material, 1000)
    if not failed then
        local dx = x - sx
        local dy = y - sy
        local dist = math.sqrt(dx*dx + dy*dy)
        dx = dx/dist
        dy = dy/dist
        dy = dy - dist/200 -- try to compensate for gravity
        local body = EntityGetFirstComponent(entity, "PhysicsBodyComponent")
        local pixelCount = ComponentGetValue2(body, "mPixelCount")
        local force = 5 * pixelCount
        PhysicsApplyForce(entity, dx * force, dy * force)
        PhysicsApplyTorque(entity, pixelCount * 0.7)
    end
end


function thiccRaytrace(x1,y1,x2,y2,width)
    local dx = x2-x1
    local dy = y2-y1
    local dist = math.sqrt(dx*dx + dy*dy)
    local nx = -dy/dist
    local ny = dx/dist
    for i = -math.ceil(width/2),math.ceil(width/2) do 
        local ox = nx*i
        local oy = ny*i
        if RaytraceSurfaces(x1 + ox, y1 + oy, x2 + ox,y2 + oy) then
            return true
        end
    end
    return false
end