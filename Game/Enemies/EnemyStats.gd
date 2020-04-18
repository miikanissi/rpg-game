extends Node

# Scene that can be instanced for each enemy to assign their stats
export(int) var max_health = 1

onready var health = max_health setget set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
