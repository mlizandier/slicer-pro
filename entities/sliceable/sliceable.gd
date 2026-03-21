extends RigidBody2D

@export var custom_texture: Texture2D:
	set(value):
		custom_texture = value
		if $Sprite2D:
			$Sprite2D.texture = value
