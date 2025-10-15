extends "res://addons/ModLoader/mod_node.gd"

var stoneskin_enabled = Setting.new(self, "StoneSkin Enabled", Setting.SETTING_FLOAT, 1, Vector2(0, 1))

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")

	settings = {
		"settings_page_name" = "Infinite StoneSkin",
		"settings_list" = [
			stoneskin_enabled
		]
	}

func _process(_delta):
	if is_instance_valid(GameManager.player):
		if stoneskin_enabled.value == 0.0:
			return
		GameManager.player.stone_skin_active = true
