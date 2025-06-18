extends Node

@export var model: Node3D

@onready var actor: CharacterBody3D = get_parent()
@onready var input_component: PlayerInputComponent = actor.get_node_or_null("PlayerInputComponent")

func _physics_process(delta: float) -> void:
	var target_mesh_pitch = deg_to_rad(clamp(input_component.pitch, -1, 1) * 15.0)
	var target_mesh_yaw = deg_to_rad(clamp(input_component.yaw, -1, 1) * 10.0)
	var target_mesh_roll = deg_to_rad(clamp(input_component.roll, -1, 1) * 30.0)

	model.rotation.x = lerp_angle(model.rotation.x, -target_mesh_pitch, delta * 5.0)
	model.rotation.y = lerp_angle(model.rotation.y, -target_mesh_yaw, delta * 5.0)
	model.rotation.z = lerp_angle(model.rotation.z, target_mesh_roll, delta * 5.0)
