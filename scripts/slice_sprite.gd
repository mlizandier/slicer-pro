extends Node2D

var slice_entry_point: Vector2
var slice_exit_point: Vector2
var slice_disabled := false

@export var custom_texture: Texture2D:
	set(value):
		print(value)
		custom_texture = value
		if $Top and $Bottom: # guard in case called before _ready
			$Top.custom_texture = value
			$Bottom.custom_texture = value


const FROZEN_GRAVITY = 0.0
const DEFAULT_GRAVITY = 1.0

signal freeze_action()

func _ready() -> void:
	$Top/Sprite2D.material = $Top/Sprite2D.material.duplicate()
	init_sliceable_objects()

	$Top.custom_texture = custom_texture
	$Bottom.custom_texture = custom_texture

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if slice_disabled:
		return
	if event.is_action_pressed("click"):
		slice_entry_point = get_global_mouse_position()
		freeze_action.emit()
	if event.is_action_released("click"):
		slice_disabled = true
		slice_exit_point = get_global_mouse_position()
		set_slice()


func set_slice() -> void:
	var sprite_top_left_corner = Vector2(
		$Top/Sprite2D.global_position.x - ($Top/Sprite2D.get_rect().size.x / 2),
		$Top/Sprite2D.global_position.y - ($Top/Sprite2D.get_rect().size.y / 2)
	)

	var entry = (slice_entry_point - sprite_top_left_corner) / $Top/Sprite2D.get_rect().size
	var exit = (slice_exit_point - sprite_top_left_corner) / $Top/Sprite2D.get_rect().size

	$Top/Sprite2D.material.set_shader_parameter('entry_point', entry)
	$Top/Sprite2D.material.set_shader_parameter('exit_point', exit)
	$Bottom/Sprite2D.material.set_shader_parameter('entry_point', entry)
	$Bottom/Sprite2D.material.set_shader_parameter('exit_point', exit)

	set_gravity(DEFAULT_GRAVITY)
	$Top.apply_impulse(Vector2(-50, -300))
	$Top.apply_torque_impulse(-3000.0)
	#$Bottom.apply_impulse(Vector2(50, 200))
	$Bottom.apply_torque_impulse(6000.0)

func set_gravity(value: float) -> void:
	$Top.gravity_scale = value
	$Bottom.gravity_scale = value

func init_sliceable_objects() -> void:
	set_gravity(FROZEN_GRAVITY)
	$Top/Sprite2D.material.set_shader_parameter('reverse', -1.0)
	$Bottom/Sprite2D.material.set_shader_parameter('reverse', 1.0)
