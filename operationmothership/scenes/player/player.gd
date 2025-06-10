extends CharacterBody3D

@export var max_speed := 50.0
@export var acceleration := 1.0
@export var deceleration := 2.0
@export var mouse_sensitivity := 0.002
@export var turn_speed := 5.0

var current_velocity := Vector3.ZERO

var yaw := 0.0
var pitch := 0.0
var roll := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

func _physics_process(delta):
	rotation = Vector3(pitch, yaw, roll)

	var input_dir = Vector3.ZERO
	var forward = -transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("move_up"):
		input_dir += forward
	if Input.is_action_pressed("move_down"):
		input_dir -= forward
	if Input.is_action_pressed("move_left"):
		input_dir -= right
	if Input.is_action_pressed("move_right"):
		input_dir += right

	input_dir = input_dir.normalized()

	var target_velocity = input_dir * max_speed
	if input_dir != Vector3.ZERO:
		current_velocity = current_velocity.lerp(target_velocity, acceleration * delta)
	else:
		current_velocity = current_velocity.lerp(Vector3.ZERO, deceleration * delta)

	velocity = current_velocity
	move_and_slide()
