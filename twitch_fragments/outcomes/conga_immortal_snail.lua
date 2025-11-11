--Immortal Snail
--From the fairest mod of all time
--detrimental
--25
--Adds an immortal snail to the game permanently
function twitch_conga_immortal_snail()
    --Adds an immortal snail to the game permanently, if this is voted in multiple times then multiple snails will be present
    local new_snail_count = tonumber(GlobalsGetValue("ti_snail_max_amount","0")) + 1
    GlobalsSetValue("ti_snail_max_amount",tostring(new_snail_count))
end

