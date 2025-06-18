extends Node
class_name PlayerInputComponent

@export var pitch := 0.0
@export var yaw := 0.0
@export var roll := 0.0

@export var speed_up := false
@export var slow_down := false
@export var shoot := false

@export var pitch_up_key := "move_up"
@export var pitch_down_key := "move_down"
@export var yaw_left_key := "move_left"
@export var yaw_right_key := "move_right"
@export var roll_left_key := "roll_left"
@export var roll_right_key := "roll_right"

@export var speed_up_key := "speed_up"
@export var slow_down_key := "slow_down"
@export var shoot_key := "shoot"

@export var mouse_sensitivity := 0.01
@export var clamp_input := true

var mouse_delta := Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative


func _physics_process(_delta: float) -> void:
	# Keyboard input
	var pitch_input = Input.get_axis(pitch_up_key, pitch_down_key)
	var yaw_input = Input.get_axis(yaw_left_key, yaw_right_key)
	var roll_input = Input.get_axis(roll_left_key, roll_right_key)

	pitch_input += -mouse_delta.y * mouse_sensitivity
	yaw_input  += mouse_delta.x * mouse_sensitivity

	#if clamp_input:
		#pitch_input = clamp(pitch_input, -1.0, 1.0)
		#roll_input = clamp(roll_input, -1.0, 1.0)

	pitch = pitch_input
	yaw = yaw_input
	roll = roll_input

	speed_up = Input.is_action_pressed(speed_up_key)
	slow_down = Input.is_action_pressed(slow_down_key)
	shoot = Input.is_action_pressed(shoot_key)

	# Reset mouse delta
	mouse_delta = Vector2.ZERO
