extends "res://addons/ModLoader/mod_node.gd"

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")
	settings = {
		"settings_page_name" = "Old Life Harvester Enabled",
		"settings_list" = [

			]
		}
	var scythe_interaction_behaviour_override = load(path_to_dir+"/scythe_interaction_behaviour_override.gd")
	scythe_interaction_behaviour_override.take_over_path("res://scripts/components/scythe_interaction_behavior.gd")
