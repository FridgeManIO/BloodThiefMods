extends "res://scripts/ui/velocity_display.gd"

func _physics_process(delta):
    _update_time_text()
    if current_time_label != null:
        current_time_label.text += "\nMODS ENABLED"
