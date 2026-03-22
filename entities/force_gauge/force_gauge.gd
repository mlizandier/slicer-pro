extends Node2D

@export var gauge_speed := 2.0

var t := 0.0
var is_moving := true
var _min_force := 0.0
var _max_force := 1.0

func _process(delta: float) -> void:
	if is_moving:
		t += delta * gauge_speed
		var force_gauge_value = (sin(t) + 1.0) / 2.0
		$ProgressBar.value = force_gauge_value

func _on_freeze_action():
	is_moving = false

func set_target_zone(min_force: int, max_force: int) -> void:
	_min_force = min_force / 100.0
	_max_force = max_force / 100.0
	var bar_width = $ProgressBar.offset_right - $ProgressBar.offset_left
	var bar_left = $ProgressBar.offset_left
	$TargetZone.offset_left = bar_left + _min_force * bar_width
	$TargetZone.offset_right = bar_left + _max_force * bar_width

func is_force_valid() -> bool:
	return $ProgressBar.value >= _min_force and $ProgressBar.value <= _max_force
