--Monstrous Drink
--You'd best not pour that
--detrimental
--5
--ohno
function twitch_conga_monstrous_drink()
    async(effect_conga_monstrous_drink)
end

function effect_conga_monstrous_drink()

    --Ensure we only trigger monstrous drink if the player has an inventory
    repeat
		wait(1);
		local player = get_player_nopoly();
	until player > 0;

    local inventory = GetInven()
    local items = EntityGetAllChildren(inventory) or {}
    SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() + 8 )
    if items ~= nil then
        for k=1,#items
        do local v = items[k]
            if EntityHasTag(v,"potion") == true then
                AddMaterialInventoryMaterial(v, "monster_powder_test", 100) --Exactly enough to be consumed in a single sip
            end
        end
    end
end
