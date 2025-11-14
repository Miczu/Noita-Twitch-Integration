_spawn_perk_reroll = _spawn_perk_reroll or spawn_perk_reroll

function spawn_perk_reroll(x, y)     
    _spawn_perk_reroll(x, y)
    local hotperks = tonumber(GlobalsGetValue("twitch_hotperks", "0"))
    local bitterperks = tonumber(GlobalsGetValue("twitch_bitterperks", "0"))
    local electricperks = tonumber(GlobalsGetValue("twitch_electricperks", "0"))
    if (hotperks > 0) then
        TrapPerksLava(x, y, hotperks)
    elseif (bitterperks > 0) then
        TrapPerksAcid(x, y, bitterperks)
    elseif (electricperks > 0) then
        TrapPerksElectricity(x, y, electricperks)
    end
end

function TrapPerksLava(x, y, count) 
    GlobalsSetValue("twitch_hotperks", tostring(count - 1))
    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/lava_perks.png","",x - 112, y + 15, "", true)
end

function TrapPerksAcid(x, y, count) 
    GlobalsSetValue("twitch_bitterperks", tostring(count - 1))
    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/acid_perks.png","",x - 112, y + 15, "", true)
end

function TrapPerksElectricity(x, y, count) 
    GlobalsSetValue("twitch_electricperks", tostring(count - 1))
    LoadPixelScene("mods/twitch-integration/files/pixel_scenes/electric_perks.png","",x - 112, y + 15, "", true)
    EntityLoad("data/entities/twitch_electricpixel.xml", x - 75, y - 10)
end
