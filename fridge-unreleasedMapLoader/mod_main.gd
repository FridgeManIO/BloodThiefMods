extends "res://addons/ModLoader/mod_node.gd"

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")
	settings = {
		"settings_page_name" = "map-bake-test enabled",
		"settings_list" = [

			]
		}
	var velocity_display_override = load(path_to_dir+"/main_screen_override.gd")
	velocity_display_override.take_over_path("res://scripts/ui/main_screen.gd")
