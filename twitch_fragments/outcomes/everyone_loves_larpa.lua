--Everyone Loves Larpa
--Everyone Loves Larpa
--curses
--40
--
dofile_once("data/scripts/lib/utilities.lua")

function twitch_everyone_loves_larpa() 
  local players = EntityGetWithTag("player_unit")
  for k=1,#players
  do v = players[k]
      local x,y = EntityGetTransform(v)
      local c = EntityLoad("mods/Twitch-integration/files/entities/misc/effect_everyone_loves_larpa.xml",x,y)
      EntityAddChild(v,c)
      print(tostring(x).." "..tostring(y))
      SetRandomSeed(x,y)
  end
  local larpa_enabled = GlobalsGetValue("twitch_everyone_loves_larpa_enabled","")
  local addlarpa
  if (string.len(larpa_enabled) > 6) then
    addlarpa = string.sub(larpa_enabled,-7,-7)
  else
    repeat
      addlarpa = random_from_array({"B","C","U","O","T","E","D"})
    until(not string.find(larpa_enabled,addlarpa))
  end

  larpa_enabled = larpa_enabled .. addlarpa
  GlobalsSetValue("twitch_everyone_loves_larpa_enabled",larpa_enabled)
  print("Larpas: "..larpa_enabled)
end