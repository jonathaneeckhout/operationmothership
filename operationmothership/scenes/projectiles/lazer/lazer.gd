extends Node3D

@export var direction := Vector3(0,0,1)
@export var speed := 300.0
@export var delete_time := 3.0
var initial_speed := 0.0

var delete_timer: Timer = null

func _ready() -> void:
	delete_timer = Timer.new()
	delete_timer.name = "DeleteTimer"
	delete_timer.wait_time = delete_time
	delete_timer.one_shot = true
	delete_timer.autostart = true
	delete_timer.timeout.connect(_on_delete_timer_timeout)
	add_child(delete_timer)

func _physics_process(delta: float) -> void:
	translate(direction * (speed + initial_speed) * delta)

func _on_delete_timer_timeout() -> void:
	queue_free()
