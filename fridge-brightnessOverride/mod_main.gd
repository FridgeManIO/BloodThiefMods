extends "res://addons/ModLoader/mod_node.gd"

var brightness = Setting.new(self, "brightness", Setting.SETTING_FLOAT, 1.0, Vector2(-20.0, 100.0))

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")

	settings = {
		"settings_page_name" = "Brightness Override",
		"settings_list" = [
			brightness
		]
	}

func _process(_delta):
	if is_instance_valid(GameManager.player):
		Signals.brightness_changed.emit(brightness.value) #Signal picked up in /entities/levels.gd
