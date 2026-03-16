extends Node2D

@export var gauge_speed := 2.0

var t := 0.0
var is_moving := true

func _process(delta: float) -> void:
	if is_moving:
		t += delta * gauge_speed
		var force_gauge_value = (sin(t) + 1.0) / 2.0
		$ProgressBar.value = force_gauge_value

func _on_freeze_action():
	is_moving = false
