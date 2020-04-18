extends KinematicBody2D

const FRICTION = 8
const ACCELERATION = 8
const MAX_SPEED = 80

enum {
	MOVE,
	FISH,
	ATTACK,
}
var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var direction_vector = Vector2.DOWN

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $"Hitbox Pivot/SwordHitbox"
onready var hurtbox = $Hurtbox

# ITEMS
onready var SwordSprite = $Sword
onready var FishingHatSprite = $"Fishing Hat"


func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = direction_vector
	Global.connect("equip", self, "_on_equip")
	_on_equip(null)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		FISH:
			fish_state()
		ATTACK:
			attack_state(delta)

func move_state(_delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Fishing/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("interact") and Global.can_fish == true:
		state = FISH
	
	if Input.is_action_just_pressed("ui_end"):
		Global.save_game()
	
# Function for Fishing once state has changed to FISH
func fish_state():
	velocity = Vector2.ZERO
	animationState.travel("Fishing")
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left"):
		state = MOVE

func attack_state(_delta):
	velocity = Vector2.ZERO
	if SwordSprite.visible:
		var playerDamage = int(PlayerStats.damage * 1.2) + 1
		swordHitbox.damage = randi() % playerDamage + 0
	else:
		var playerDamage = int(PlayerStats.damage) + 1
		swordHitbox.damage = randi() % playerDamage + 0
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE


func save():
	var save_dict = {
		pos={
			x=get_position().x,
			y=get_position().y
		},
		stage = self.get_parent().get_parent().get_path()
	}
	return save_dict
	
func _on_equip(_dictionary):
	SwordSprite.hide()
	FishingHatSprite.hide()
	var items = Global.equippedItems
	for i in items:
		if items.get(i):
			if items.get(i) == "Sword":
				SwordSprite.show()
			elif items.get(i) == "FishingHat":
				FishingHatSprite.show()


func _on_SwordHitbox_area_entered(_area):
	PlayerStats.gain_experience(swordHitbox.damage * 5, "max_hp")
	PlayerStats.gain_experience(swordHitbox.damage * 10, "melee")


func _on_Hurtbox_area_entered(area):
	PlayerStats.lose_hp(area.damage)
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.6)
	if PlayerStats.cur_hp <= 0:
		PlayerStats.gain_hp(100)
		var d = {"spawnpoint": "Main spawn"}
		var caveScene = "res://Game/Stages/World.tscn"
		Global.switchScene(caveScene, d)
