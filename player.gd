extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var gravity: float = 900.0
@export var fall_threshold: float = 500.0  # Y position below which player respawns

var spawn_position: Vector2

func _ready() -> void:
    spawn_position = global_position

func _physics_process(delta: float) -> void:
    # Check if player fell off the level
    if global_position.y > fall_threshold:
        respawn()

    # Apply gravity
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Handle horizontal movement
    var direction := Input.get_axis("move_left", "move_right")
    if direction:
        velocity.x = direction * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)

    move_and_slide()

func respawn() -> void:
    global_position = spawn_position
    velocity = Vector2.ZERO
