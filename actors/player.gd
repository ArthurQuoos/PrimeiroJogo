extends CharacterBody2D

@export_group("Horizontal")
@export var max_speed: float = 260.0
@export var acceleration: float = 1400.0
@export var friction: float = 1800.0
@export var air_control: float = 0.6

@export_group("Pulo")
@export var jump_height: float = 130.0
@export var time_to_peak: float = 0.38
@export var time_to_descent: float = 0.28
@export var max_fall_speed: float = 900.0
@export var coyote_time: float = 0.10
@export var jump_buffer_time: float = 0.10
@export var jump_cut: float = 0.4

@onready var jump_velocity: float = -2.0 * jump_height / time_to_peak
@onready var jump_gravity: float = 2.0 * jump_height / (time_to_peak * time_to_peak)
@onready var fall_gravity: float = 2.0 * jump_height / (time_to_descent * time_to_descent)
@onready var spawn_position: Vector2 = global_position

var coyote_timer := 0.0
var buffer_timer := 0.0

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump(delta)
	_handle_horizontal(delta)
	move_and_slide()
	_check_head_bump()
	if global_position.y > 900.0:
		global_position = spawn_position
		velocity = Vector2.ZERO

func _current_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(velocity.y + _current_gravity() * delta, max_fall_speed)

func _handle_jump(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		buffer_timer = jump_buffer_time
	else:
		buffer_timer -= delta

	if buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		buffer_timer = 0.0
		coyote_timer = 0.0

	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= jump_cut

func _handle_horizontal(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var control := 1.0 if is_on_floor() else air_control
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * control * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * control * delta)

func _check_head_bump() -> void:
	if not is_on_ceiling():
		return
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.has_method("bump") and collision.get_normal().y > 0.5:
			collider.bump()
