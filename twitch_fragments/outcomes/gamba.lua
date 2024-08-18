--Gamba
--Lucky... or maybe not x2?
--unknown
--20
--Picks two more outcomes at random
function twitch_gamba()
    local outcome_count = 2

    -- just a little more randomness...
    if math.random(1000) == 1 then
        outcome_count = outcome_count + math.random(2)
    end

    -- pre-filtering avoids looping an unknown number of times
    local possible_outcomes = {}
    for _, outcome in ipairs(ti_outcomes) do
        if outcome.enabled then
            table.insert(possible_outcomes, outcome)
        end
    end

    -- avoid infinite loop (edge case)
    if #possible_outcomes <= outcome_count then
        for i, outcome in ipairs(possible_outcomes) do
            if outcome.id == "gamba" then
                table.remove(possible_outcomes, i)
            end
        end
    end

    if #possible_outcomes == 0 then
        GamePrintImportant("Nothing", "whoa")
        return
    end

    local gamba_outcomes = {}
    local gamba_names = {}

    for i = 1, outcome_count do
        local index = math.random(1, #possible_outcomes)
        local outcome = possible_outcomes[index]
        if outcome ~= nil then
            table.remove(possible_outcomes, index) -- avoid duplicates
            table.insert(gamba_outcomes, outcome) -- to call functions after showing message
            table.insert(gamba_names, outcome.name)
        end
    end

    gamba_names = table.concat(gamba_names, " & ")
    GamePrintImportant(gamba_names, "whoa")
    GamePrint("GAMBA: " .. gamba_names)

    -- call function after showing message, so that the message order is correct if Gamba is chosen by Gamba
    for _, outcome in ipairs(gamba_outcomes) do
        outcome.fn()
    end
end
