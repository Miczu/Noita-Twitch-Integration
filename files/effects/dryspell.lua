local players = EntityGetWithTag("player_unit")

if #players > 0 then
    local player_id = players[1]

    local damage_model = EntityGetComponent(player_id, "DamageModelComponent")[1]

    -- check if fire was extinguished
    if ComponentGetValue2(damage_model, "is_on_fire") then
        local frames = ComponentGetValue2(damage_model, "mFireFramesLeft")
        -- so that fire can be reignited for the correct duration
        GlobalsSetValue("DRYSPELL_FIRE_END", GameGetFrameNum() + frames)
    else
        local fire_end = tonumber(GlobalsGetValue("DRYSPELL_FIRE_END")) or 0
        if GameGetFrameNum() < fire_end then
            -- extinguished: resume burning
            local duration = fire_end - GameGetFrameNum() -- full duration: ComponentGetValue2(damage_model, "mFireDurationFrames")
            ComponentSetValue2(damage_model, "mFireFramesLeft", duration)
            ComponentSetValue2(damage_model, "is_on_fire", true)
        end
    end
end
