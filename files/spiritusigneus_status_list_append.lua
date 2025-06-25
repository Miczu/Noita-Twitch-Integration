local nerf_potions_effects =
{
    {
        id="CHAOTIC_TELEPORTATION",
        ui_name="Useless Teleportation",
        ui_description="Randomly teleports you very short distances",
        ui_icon="data/ui_gfx/status_indicators/teleportation.png",
        effect_entity="mods/twitch-integration/files/entities/misc/effect_chaotic_teleportation.xml"
    },
	{
		id="WEAK_AMBROSIA",
		ui_name="Weak Ambrosia",
		ui_description="Reduces all damage by half",
		ui_icon="mods/twitch-integration/files/ui_gfx/status_indicators/protection_half.png",
		effect_entity="mods/twitch_integration/files/entities/misc/effect_weak_ambrosia.xml"
	},
	{
		id="SCAMBROSIA",
		ui_name="Scambrosia",
		ui_description="Does not reduce damage at all",
		ui_icon="mods/twitch-integration/files/ui_gfx/status_indicators/protection_none.png",
		effect_entity="mods/twitch-integration/files/entities/misc/effect_scambrosia.xml"
	},
	{
		id="CITRUS",
		ui_name="Citrusy",
		ui_description="You smell and taste citrusy",
		ui_icon="mods/twitch-integration/files/ui_gfx/status_indicators/citrus.png",
		effect_entity="mods/twitch-integration/files/entities/misc/effect_citrus.xml"
	},
}

for _, effect in pairs(nerf_potions_effects) do
    table.insert(status_effects, effect)
end