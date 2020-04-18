extends Area2D

# This Hurtbox scene is instanced for all hurtboxes

const HitEffect = preload("res://Game/Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position - Vector2(0, 16)


func _on_Timer_timeout():
	self.invincible = false

# Switching monitorable off and starting a timer
# When timer goes off monitorable is turned back on
# This is a way to make hurtbox activate again even if enemy
# hitbox doesnt leave your hurtbox

func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable", false)


func _on_Hurtbox_invincibility_ended():
	monitorable = true
