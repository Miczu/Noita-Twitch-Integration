--Wandstravaganza
--For 10 seconds, about 90% of wand-capable enemies receive biome-tiered wands!
--detrimental
--20
--Enemy wands vanish on death; player-acquired wands are yours to keep.

function twitch_wandstravaganza()
    if not TI_Wandstravaganza then
        TI_Wandstravaganza = dofile("mods/twitch-integration/files/wandstravaganza.lua")
    end
    add_persistent_func("ti_wandstravaganza", TI_Wandstravaganza.update)
    async(function()
        local player = get_player_nopoly()
        while not player or player == 0 do
            wait(1)
            player = get_player_nopoly()
        end
        TI_Wandstravaganza.start(player)
    end)
end
