local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local owner = EntityGetClosestWithTag(x, y, "mortal")

EntityAddComponent( owner, "LuaComponent", {
    execute_every_n_frame = "-1",
    script_shot = "mods/twitch-integration/files/effects/moneyshot_effect.lua"
})
local icon = EntityLoad("mods/twitch-integration/files/effects/moneyshot_icon.xml", x, y)
EntityAddChild(owner, icon)