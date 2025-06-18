extends Node
class_name PlayerMovement

@export var max_speed := 100.0
@export var min_speed := 0.0
@export var acceleration := 25.0
@export var deceleration := 20.0
@export var current_speed := 50.0

@export var yaw_speed := 1.5
@export var pitch_speed := 1.5
@export var roll_speed := 2.5

@export var speed_lerp_speed := 100
@export var rotation_lerp_speed := 5.0

@onready var actor: CharacterBody3D = get_parent()
@onready var input_component: PlayerInputComponent = actor.get_node_or_null("PlayerInputComponent")

var pitch_smoothed := 0.0
var yaw_smoothed := 0.0
var roll_smoothed := 0.0

func _physics_process(delta: float) -> void:
	update_speed(delta)
	apply_rotation(delta)
	update_movement()

func update_speed(delta: float):
	var target_speed = current_speed
	if Input.is_action_pressed("speed_up"):
		target_speed += acceleration * delta
	elif Input.is_action_pressed("slow_down"):
		target_speed -= deceleration * delta

	# Clamp base speed
	target_speed = clamp(target_speed, min_speed, max_speed)

	current_speed = lerp(current_speed, target_speed, delta * 100)

func apply_rotation(delta: float):
	# Target rotation deltas
	var target_pitch = -input_component.pitch * pitch_speed
	var target_yaw = -input_component.yaw * yaw_speed
	var target_roll = input_component.roll * roll_speed

	# Smooth (lerp) the inputs
	pitch_smoothed = lerp(pitch_smoothed, target_pitch, rotation_lerp_speed * delta)
	yaw_smoothed = lerp(yaw_smoothed, target_yaw, rotation_lerp_speed * delta)
	roll_smoothed = lerp(roll_smoothed, target_roll, rotation_lerp_speed * delta)

	# Apply in plane-relative space
	actor.rotate_object_local(Vector3.RIGHT, pitch_smoothed * delta)
	actor.rotate_object_local(Vector3.UP, yaw_smoothed * delta)
	actor.rotate_object_local(Vector3.BACK, roll_smoothed * delta)

func update_movement():
	actor.velocity = actor.global_transform.basis.z * current_speed
	actor.move_and_slide()
