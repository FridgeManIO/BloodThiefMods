extends "res://addons/ModLoader/mod_node.gd"

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")

	var build_map_override = load(path_to_dir+"/func_godot_map_override.gd")
	build_map_override.take_over_path("res://addons/func_godot/src/map/func_godot_map.gd")
