extends "res://Player/Weapon.gd"

export var fire_range = 10

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
