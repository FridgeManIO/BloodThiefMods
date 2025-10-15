extends "res://scripts/components/scythe_interaction_behavior.gd"

func can_dash(player: Player):
    return _can_dash and not _dash_on_cooldown and !player.is_on_floor() and player.on_ground_ray.get_collider() == null
