extends Node3D


func _ready() -> void:
	Game.map = $Map
	Game.projectiles = $Entities/Projectiles
