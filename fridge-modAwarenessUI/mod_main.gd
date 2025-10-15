extends "res://addons/ModLoader/mod_node.gd"

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")
	settings = {
		"settings_page_name" = "Mod Awareness Enabled",
		"settings_list" = [

			]
		}
	var velocity_display_override = load(path_to_dir+"/velocity_display_override.gd")
	velocity_display_override.take_over_path("res://scripts/ui/velocity_display.gd")
