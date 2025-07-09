dofile_once("data/scripts/lib/utilities.lua")

local larpa_enabled = GlobalsGetValue("twitch_everyone_loves_larpa_enabled",".")
larpa_enabled = string.sub(larpa_enabled,2)
GlobalsSetValue("twitch_everyone_loves_larpa_enabled",larpa_enabled)
print("Larpas: 0"..larpa_enabled)