extends Node2D

const LEVEL_PATHS: Array[LevelData] = [
	preload("res://resources/levels/level_1.tres"),
	preload("res://resources/levels/level_2.tres"),
	preload("res://resources/levels/level_3.tres"),
	preload("res://resources/levels/level_4.tres"),
]

func _input(event: InputEvent) -> void:
	for i in range(1, 5):
		if event.is_action_pressed(str(i)):
			if $SliceSprite.slice_disabled:
				return
			var level = load_level_data(i)
			$SliceSprite.custom_texture = level.texture
			$SliceSprite.set_target_zone(level.min_force, level.max_force)

func load_level_data(index: int) -> LevelData:
	var level: LevelData = LEVEL_PATHS[index - 1]
	print(level.min_force, level.max_force)
	return level
