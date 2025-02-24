
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
local comp = EntityGetFirstComponentIncludingDisabled(entity_id,"ProjectileComponent")
local shooter = ComponentGetValue2(comp,"mWhoShot")
local pcomp = EntityGetFirstComponentIncludingDisabled(shooter, "PhysicsBodyComponent")
local stuck_check_coords = {{-3,0},{0,-3},{3,0},{0,3}}
local blocked = false
for k=1,#stuck_check_coords do
    if Raytrace( x, y, x + stuck_check_coords[k][1], y + stuck_check_coords[k][2] ) then
        blocked = true
        break
    end
end
if not blocked then
    x,y = GamePosToPhysicsPos(x,y)
    PhysicsComponentSetTransform( pcomp, x, y)
end
