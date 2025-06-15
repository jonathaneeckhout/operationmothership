extends CharacterBody3D

@export var max_speed := 100.0
@export var min_speed := 0.0
@export var acceleration := 25.0
@export var deceleration := 20.0
@export var afterburner_multiplier := 1.5
@export var current_speed := 50.0

@export var yaw_speed := 1.5
@export var pitch_speed := 1.5
@export var roll_speed := 2.5

@export var speed_lerp_speed := 100
@export var rotation_lerp_speed := 5.0


@onready var plane_mesh := $Model

var pitch_input := 0.0
var yaw_input := 0.0
var roll_input := 0.0

var pitch_smoothed := 0.0
var yaw_smoothed := 0.0
var roll_smoothed := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	handle_input()
	update_speed(delta)
	apply_rotation(delta)
	update_movement()

func handle_input():
	pitch_input = Input.get_axis("move_up", "move_down")
	
	yaw_input = Input.get_axis("move_left", "move_right")
	# Get roll (A/D)
	roll_input = Input.get_axis("roll_left", "roll_right")

func update_speed(delta: float):
	var target_speed = current_speed
	if Input.is_action_pressed("speed_up"):
		target_speed += acceleration * delta
	elif Input.is_action_pressed("speed_down"):
		target_speed -= deceleration * delta

	# Clamp base speed
	target_speed = clamp(target_speed, min_speed, max_speed)

	current_speed = lerp(current_speed, target_speed, delta * 100)

func apply_rotation(delta: float):
	# Target rotation deltas
	var target_pitch = -pitch_input * pitch_speed
	var target_yaw = -yaw_input * yaw_speed
	var target_roll = roll_input * roll_speed

	# Smooth (lerp) the inputs
	pitch_smoothed = lerp(pitch_smoothed, target_pitch, rotation_lerp_speed * delta)
	yaw_smoothed = lerp(yaw_smoothed, target_yaw, rotation_lerp_speed * delta)
	roll_smoothed = lerp(roll_smoothed, target_roll, rotation_lerp_speed * delta)

	# Apply in plane-relative space
	rotate_object_local(Vector3.RIGHT, pitch_smoothed * delta)
	rotate_object_local(Vector3.UP, yaw_smoothed * delta)
	rotate_object_local(Vector3.BACK, roll_smoothed * delta)

	# Lean the plane mesh visually (tilt feedback for all axes)
	var target_mesh_pitch = deg_to_rad(clamp(pitch_input, -1, 1) * 15.0)
	var target_mesh_yaw = deg_to_rad(clamp(yaw_input, -1, 1) * 10.0)
	var target_mesh_roll = deg_to_rad(clamp(roll_input, -1, 1) * 30.0)

	plane_mesh.rotation.x = lerp_angle(plane_mesh.rotation.x, -target_mesh_pitch, delta * 5.0)
	plane_mesh.rotation.y = lerp_angle(plane_mesh.rotation.y, -target_mesh_yaw, delta * 5.0)
	plane_mesh.rotation.z = lerp_angle(plane_mesh.rotation.z, target_mesh_roll, delta * 5.0)


func update_movement():
	velocity = global_transform.basis.z * current_speed
	move_and_slide()
