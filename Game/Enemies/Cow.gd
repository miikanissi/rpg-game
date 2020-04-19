extends KinematicBody2D

var knockback = Vector2.ZERO
const DeathEffect = preload("res://Game/Effects/DeathEffect.tscn")

onready var hurtbox = $Hurtbox
onready var hitbox = $Hitbox
onready var sprite = $AnimatedSprite
onready var stats = $EnemyStats
onready var playerDetectionZone = $PlayerDetectionZone

export var ACCELERATION = 200
export var MAX_SPEED = 30
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var state = CHASE

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			sprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			sprite.play("Walk")
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x > 0
	
	velocity = move_and_slide(velocity)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()

func _on_EnemyStats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position

# Runescape style damage calculation
# Very simple random number between max hit and 0
func _on_Hitbox_area_entered(_area):
	hitbox.damage = randi() % (stats.damage + 1) + 0
