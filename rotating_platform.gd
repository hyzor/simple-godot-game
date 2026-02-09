extends AnimatableBody2D

@export var rotation_speed: float = 1.5
@export var max_rotation_degrees: float = 30.0
@export var continuous_rotation: bool = false

var time_elapsed: float = 0.0

func _physics_process(delta: float) -> void:
	time_elapsed += delta
	
	if continuous_rotation:
		rotation += rotation_speed * delta
	else:
		# Rocking motion using sine wave for smooth back-and-forth
		rotation_degrees = max_rotation_degrees * sin(time_elapsed * rotation_speed)
