extends Node2D

func _ready() -> void:
	var level := GameState.current_level
	if level:
		$SliceSprite.custom_texture = level.texture
		$SliceSprite.set_target_zone(level.min_force, level.max_force)
