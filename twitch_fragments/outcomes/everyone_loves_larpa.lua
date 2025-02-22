--Everyone Loves Larpa
--Everyone Loves Larpa
--curses
--40
--
dofile_once("data/scripts/lib/utilities.lua")

function twitch_everyone_loves_larpa()
  local players = get_player_as_table()
  for k=1,#players do
    local v = players[k]
    -- Remove older instances of projectile larpa script
    local entities = EntityGetAllChildren(v)
    for l=1,#entities do
      local e = entities[l]
      local s = EntityGetFirstComponent(e,"LuaComponent","larpa_main")
      if (s ~= nil) then
        EntityRemoveComponent(e,s)
      end
    end
    -- Add new instance of projectile larpa script
    local x,y = EntityGetTransform(v)
    local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_everyone_loves_larpa.xml",x,y)
    EntityAddTag(c,"larpa_entity")
    EntityAddChild(v,c)
    SetRandomSeed(x,y)
  end

  --[[ Stack larpa with subsequent votes
  local larpa_enabled = GlobalsGetValue("twitch_everyone_loves_larpa_enabled","")
  local addlarpa
  if (string.len(larpa_enabled) > 6) then
    addlarpa = string.sub(larpa_enabled,-7,-7)
  else
    repeat
      addlarpa = random_from_array({"B","C","U","O","T","E","D"})
    until(not string.find(larpa_enabled,addlarpa))
  end
  --]]

  ---[[ Extend larpa with subsequent votes
  local larpa_enabled = GlobalsGetValue("twitch_everyone_loves_larpa_enabled","")
  if (larpa_enabled == "") then
    addlarpa = random_from_array({"B","E","O"})
  else 
    addlarpa = string.sub(larpa_enabled,-1)
  end
  --]]
  larpa_enabled = larpa_enabled .. addlarpa
  GlobalsSetValue("twitch_everyone_loves_larpa_enabled",larpa_enabled)
  print("Larpas: "..larpa_enabled)
end