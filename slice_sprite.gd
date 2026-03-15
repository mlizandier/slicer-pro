extends Node2D

var has_click := false
var click_entry : Vector2;
var click_exit : Vector2;

const FROZEN_GRAVITY = 0.0
const DEFAULT_GRAVITY = 1.0

func _ready() -> void:
	$Top/Sprite2D.material = $Top/Sprite2D.material.duplicate()
	init_sliceable_objects()

func _input(event: InputEvent) -> void:
	if event.is_action("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("click"):
		has_click = true
		click_entry = get_global_mouse_position();
	if event.is_action_released("click"):
		has_click = false
		click_exit = get_global_mouse_position();
		set_slice()
		

func set_slice():
	var entry_point = Vector2($Top/Sprite2D.global_position.x - ($Top/Sprite2D.get_rect().size.x / 2), $Top/Sprite2D.global_position.y - ($Top/Sprite2D.get_rect().size.y / 2))
	
	var entry = (click_entry - entry_point) /  $Top/Sprite2D.get_rect().size
	var exit = (click_exit - entry_point)  /  $Top/Sprite2D.get_rect().size
	
	$Top/Sprite2D.material.set_shader_parameter('entry_point', entry)
	$Top/Sprite2D.material.set_shader_parameter('exit_point', exit)
	$Bottom/Sprite2D.material.set_shader_parameter('entry_point', entry)
	$Bottom/Sprite2D.material.set_shader_parameter('exit_point', exit)

	set_gravity(DEFAULT_GRAVITY)
	$Top.apply_impulse(Vector2(-50, -300))
	$Top.apply_torque_impulse(-3000.0)
	#$Bottom.apply_impulse(Vector2(50, 200))
	$Bottom.apply_torque_impulse(6000.0)

func set_gravity(value: float):
	$Top.gravity_scale = value
	$Bottom.gravity_scale = value

func init_sliceable_objects():
	set_gravity(FROZEN_GRAVITY)
	$Top/Sprite2D.material.set_shader_parameter('reverse', -1.0)
	$Bottom/Sprite2D.material.set_shader_parameter('reverse', 1.0)
