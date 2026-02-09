extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var gravity: float = 900.0
@export var fall_threshold: float = 500.0  # Y position below which player respawns
@export var debug_speed: float = 600.0  # Speed in debug mode

var spawn_position: Vector2
var debug_mode: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	spawn_position = global_position
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Toggle debug mode
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug_mode()
	
	if debug_mode:
		_handle_debug_movement()
	else:
		_handle_normal_movement(delta)

func _handle_normal_movement(delta: float) -> void:
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
	velocity.x = direction * speed if direction else move_toward(velocity.x, 0, speed)

	move_and_slide()

func _handle_debug_movement() -> void:
	# Free movement in all directions with no collision
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	velocity.x = direction_x * debug_speed
	velocity.y = direction_y * debug_speed
	
	move_and_slide()

func toggle_debug_mode() -> void:
	debug_mode = !debug_mode
	
	if debug_mode:
		# Enable noclip
		collision_layer = 0
		collision_mask = 0
		collision_shape.disabled = true
		velocity = Vector2.ZERO
		print("Debug mode enabled - Noclip active, Speed: ", debug_speed)
	else:
		# Disable noclip
		collision_layer = 2
		collision_mask = 7
		collision_shape.disabled = false
		velocity = Vector2.ZERO
		print("Debug mode disabled")

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO

func die() -> void:
	if not debug_mode:
		respawn()
