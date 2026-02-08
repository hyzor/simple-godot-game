extends AnimatableBody2D

@export var move_distance: float = 100.0
@export var move_speed: float = 50.0
@export var move_direction: Vector2 = Vector2.RIGHT
@export var wait_time: float = 1.0

var start_position: Vector2
var target_position: Vector2
var moving_to_target: bool = true
var wait_timer: float = 0.0

func _ready() -> void:
    start_position = global_position
    target_position = start_position + (move_direction.normalized() * move_distance)

func _physics_process(delta: float) -> void:
    if wait_timer > 0:
        wait_timer -= delta
        return

    var destination = target_position if moving_to_target else start_position
    var direction = (destination - global_position).normalized()
    var distance = global_position.distance_to(destination)
    var move_amount = move_speed * delta

    if distance <= move_amount:
        global_position = destination
        moving_to_target = !moving_to_target
        wait_timer = wait_time
    else:
        global_position += direction * move_amount
