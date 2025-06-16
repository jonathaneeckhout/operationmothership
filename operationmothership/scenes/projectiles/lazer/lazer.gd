extends Node3D

@export var direction := Vector3()
@export var speed := 0.0

func _physics_process(delta: float) -> void:
	translate(direction * speed * delta)
