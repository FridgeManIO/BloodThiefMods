extends "res://scripts/ui/main_screen.gd"

func get_map_path(file)-> String:
    var f = FileAccess.open(file, FileAccess.READ)
    while true:
        var line = f.get_line()
        if line[0]!='#':
            f.close()
            return line


    f.close()
    return ""


func _on_custom_maps_button_pressed() -> void :
    var map_path = get_map_path("res://levels.txt")
    if map_path == "":
        GameManager.change_level_scene("res://scenes/levels/experimental/dummy_runtime_map_build.tscn")
    print("Loading level"+map_path)
    GameManager.change_level_scene(map_path)
