extends Control

const LEVELS: Array[LevelData] = [
	preload("res://resources/levels/level_1.tres"),
	preload("res://resources/levels/level_2.tres"),
	preload("res://resources/levels/level_3.tres"),
	preload("res://resources/levels/level_4.tres"),
]

const CARD_SIZE := Vector2(60, 70)
const CARD_GAP := 8
const COLUMNS := 4

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	# Title
	var title := Label.new()
	title.text = "SLICER PRO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))
	title.position = Vector2(0, 16)
	title.size = Vector2(320, 20)
	add_child(title)

	# Subtitle
	var subtitle := Label.new()
	subtitle.text = "Select a level"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 8)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	subtitle.position = Vector2(0, 34)
	subtitle.size = Vector2(320, 14)
	add_child(subtitle)

	# Cards grid
	var grid_width := COLUMNS * CARD_SIZE.x + (COLUMNS - 1) * CARD_GAP
	var grid_start_x := (320.0 - grid_width) / 2.0
	var grid_start_y := 56.0

	for i in range(LEVELS.size()):
		var level := LEVELS[i]
		var col := i % COLUMNS
		var row := i / COLUMNS
		var card_pos := Vector2(
			grid_start_x + col * (CARD_SIZE.x + CARD_GAP),
			grid_start_y + row * (CARD_SIZE.y + CARD_GAP)
		)
		_create_card(level, i, card_pos)

func _create_card(level: LevelData, index: int, pos: Vector2) -> void:
	var card := Button.new()
	card.position = pos
	card.size = CARD_SIZE
	card.flat = true
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	# Card background style
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.18, 0.18, 0.22, 1.0)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.3, 0.3, 0.35)
	card.add_theme_stylebox_override("normal", style)

	# Hover style
	var hover_style := style.duplicate()
	hover_style.bg_color = Color(0.24, 0.24, 0.3, 1.0)
	hover_style.border_color = Color(0.5, 0.5, 0.6)
	card.add_theme_stylebox_override("hover", hover_style)

	# Pressed style
	var pressed_style := style.duplicate()
	pressed_style.bg_color = Color(0.14, 0.14, 0.18, 1.0)
	card.add_theme_stylebox_override("pressed", pressed_style)

	card.pressed.connect(_on_level_selected.bind(index))
	add_child(card)

	# Thumbnail
	var thumb := TextureRect.new()
	thumb.texture = level.texture
	thumb.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	thumb.position = Vector2(6, 4)
	thumb.size = Vector2(CARD_SIZE.x - 12, 36)
	thumb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(thumb)

	# Level name
	var name_label := Label.new()
	name_label.text = level.label
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 7)
	name_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	name_label.position = Vector2(0, 42)
	name_label.size = Vector2(CARD_SIZE.x, 12)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(name_label)

	# Difficulty stars
	var difficulty := _calc_difficulty(level.min_force, level.max_force)
	var stars_label := Label.new()
	var stars_text := ""
	for s in range(3):
		if s < difficulty:
			stars_text += "+"
		else:
			stars_text += "-"
	stars_label.text = stars_text
	stars_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stars_label.add_theme_font_size_override("font_size", 7)
	stars_label.add_theme_color_override("font_color", Color(0.9, 0.75, 0.2))
	stars_label.position = Vector2(0, 54)
	stars_label.size = Vector2(CARD_SIZE.x, 12)
	stars_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(stars_label)

func _calc_difficulty(min_force: int, max_force: int) -> int:
	var range_size := max_force - min_force
	if range_size >= 50:
		return 1
	elif range_size >= 20:
		return 2
	else:
		return 3

func _on_level_selected(index: int) -> void:
	GameState.current_level = LEVELS[index]
	get_tree().change_scene_to_file("res://main.tscn")
