--Monstrous Drink
--You'd best not pour that
--detrimental
--5
--ohno
function twitch_conga_monstrous_drink()
    local inventory = GetInven()
    local items = EntityGetAllChildren(inventory)
    local potiontable = {}
    SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 8 )
    if items ~= nil then
        for k=1,#items
        do local v = items[k]
            if EntityHasTag(v,"potion") == true then
                AddMaterialInventoryMaterial(v, "monster_powder_test", 20)
            end
        end
    end
end
