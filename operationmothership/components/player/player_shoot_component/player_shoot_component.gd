extends Node
class_name PlayerSchoot

@export var bullet_scene: PackedScene
@export var fire_rate := 0.3

@onready var actor: CharacterBody3D = get_parent()
@onready var input_component: PlayerInputComponent = actor.get_node_or_null("PlayerInputComponent")

var weaponTimer: Timer = null

func _ready() -> void:
	weaponTimer = Timer.new()
	weaponTimer.name = "WeaponTimer"
	weaponTimer.wait_time = fire_rate
	weaponTimer.one_shot = true
	weaponTimer.autostart = false
	add_child(weaponTimer)

func _physics_process(delta: float) -> void:
	if !weaponTimer.is_stopped():
		return
	
	if !input_component.shoot:
		return
	
	var bullet = bullet_scene.instantiate()
	bullet.transform = actor.global_transform
	Game.projectiles.add_child(bullet)
	
	weaponTimer.start(fire_rate)
