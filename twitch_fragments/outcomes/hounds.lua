--Hounds
--Smithers, release the hounds
--enemies
--200
--todo
function twitch_hounds()
    
    local hounds = {
        superStrong = {
            "data/entities/animals/bigzombie.xml"
        },
        strong = {
            "data/entities/animals/zombie.xml"
        },
        weak = {
            "data/entities/animals/zombie_weak.xml"
        }
    }
    local selected = "weak"
    local amount = Random(6,9)
    for i = 1,amount do
        local rng = Random(1, 10)
        if rng ==1 then
            selected = "superStrong"
        elseif rng >=8 then
            selected = "weak"
        else
            selected = "strong"
        end
        for _, entity in pairs(hounds[selected]) do
            spawn_something(entity, Random(30, 70), Random(90, 150), true, false, append_viewer_name)
        end
    end
end
