extends "res://addons/ModLoader/mod_node.gd"

var in_freecam:=false

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")

func _process(delta):
	if is_instance_valid(GameManager.player) and Input.is_action_just_pressed("toggle_debug"):
		if not in_freecam:
			GameManager.player.change_states(GameManager.player.free_cam_state.name, GameManager.player, null)
			in_freecam = true
		else:
			GameManager.player.change_states(GameManager.player.in_air_state.name, GameManager.player, null)
			in_freecam = false