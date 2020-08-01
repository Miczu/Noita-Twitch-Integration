_spawn_perk_reroll = _spawn_perk_reroll or spawn_perk_reroll

function spawn_perk_reroll(x, y)     
    _spawn_perk_reroll(x, y)
    local hotperks = tonumber(GlobalsGetValue("twitch_hotperks", "0"))
    local bitterperks = tonumber(GlobalsGetValue("twitch_bitterperks", "0"))
    if (hotperks > 0) then
        TrapPerksLava(x, y, hotperks)
    elseif (bitterperks > 0) then
        TrapPerksAcid(x, y, bitterperks)
    end
end

function TrapPerksLava(x, y, count) 
    GlobalsSetValue("twitch_hotperks", tostring(count - 1))
    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/lava_perks.png","",x - 112, y - 35, "", true)
    GamePrint("Lava " .. GlobalsGetValue("twitch_hotperks", "0"))
end

function TrapPerksAcid(x, y, count) 
    GlobalsSetValue("twitch_bitterperks", tostring(count - 1))
    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/acid_perks.png","",x - 112, y - 35, "", true)
    GamePrint("Acid " .. GlobalsGetValue("twitch_bitterperks", "0"))
end

CheckTrapPerks()
