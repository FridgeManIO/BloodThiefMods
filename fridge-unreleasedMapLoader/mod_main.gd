extends "res://addons/ModLoader/mod_node.gd"

var interesting_levels = {
	"jon_level":"res://scenes/levels/jon_level.tscn",
	"gym":"res://scenes/levels/gym.tscn",
	"haunted_castle":"res://scenes/levels/haunted_castle.tscn",
	"lava_bridge":"res://scenes/levels/lavabridge.tscn",
	"practice":"res://scenes/levels/practice.tscn",
	"speed_garden":"res://scenes/levels/garden/speed_garden.tscn",
	"garden_golem":"res://scenes/levels/garden/garden_golem.tscn",
	"gl_compat_garden":"res://scenes/levels/garden/gl_compat_garden.tscn",
	"garden_august":"res://scenes/levels/garden/garden_august.tscn",
	"garden_august_2":"res://scenes/levels/garden/garden_august_2.tscn",
	"garden":"res://scenes/levels/garden/garden.tscn",
	"easy_sewer_garden":"res://scenes/levels/garden/easy_sewer_garden1.tscn",
	"drive_train":"res://scenes/levels/full_game_levels/drive_train/drive_train.tscn",
	}

func load_level(level_name):
	GameManager.change_level_scene(level_name)

var choice_array = []

func init():
	ModLoader.mod_log(name_pretty + " mod loaded")

	for key in interesting_levels:
		choice_array.append(Setting.new(self, key, Setting.SETTING_BUTTON, Callable(load_level).bind(interesting_levels[key])))

	settings = {
		"settings_page_name" = "Unreleased Maps",
		"settings_list" = choice_array
		}
