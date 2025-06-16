extends Node
class_name PlayerInput

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


func _physics_process(_delta: float) -> void:
	pitch = Input.get_axis(pitch_up_key, pitch_down_key)
	yaw = Input.get_axis(yaw_left_key, yaw_right_key)
	roll = Input.get_axis(roll_left_key, roll_right_key)
	
	speed_up = Input.is_action_pressed(speed_up_key)
	slow_down = Input.is_action_pressed(slow_down_key)
	
	shoot = Input.is_action_pressed(shoot_key)
