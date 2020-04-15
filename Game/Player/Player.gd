extends KinematicBody2D

signal experience_gained(growth_data)

# Character stats
export (int) var fishing = 1
export (int) var woodchopping = 1
export (int) var mining = 1

# Leveling system
export (int) var level = 1

var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)

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
onready var SwordSprite = $Sword

# onready var equipments = get_tree().get_root().get_node("Game").get_node("InventoryLayer").get_node("Inventory").get_node("Inventory background").get_node("Item container")

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = direction_vector
# warning-ignore:return_value_discarded
	Global.connect("equip", self, "_on_equip")
	_on_equip(null)
# Simple state machineequipment_changed
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		FISH:
			fish_state()
		ATTACK:
			attack_state(delta)

# Function for moving in 8 directions and triggering correct animations
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
	if Input.is_action_just_pressed("Interact"):
		state = ATTACK
	
	if Input.is_action_just_pressed("Interact") and Global.can_fish == true:
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
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
# Function for experience growth
# warning-ignore:shadowed_variable
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)
	
func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)
	
	var stats = ['max_hp', 'strength', 'magic']
	var random_stat = stats[randi() % stats.size()]
	set(random_stat, get(random_stat) + randi() % 4)

# Function to save player data as a dictionary
func save():
	var save_dict = {
		pos={
			x=get_position().x,
			y=get_position().y
		},
		fishing = fishing,
		woodchopping = woodchopping,
		mining = mining,
		stage = self.get_parent().get_parent().get_path()
	}
	return save_dict
	
func _on_equip(_dictionary):
	print("Receiving signal")
	SwordSprite.hide()
	var items = Global.equippedItems
	for i in items:
		if items.get(i):
			if items.get(i) == "Sword":
				SwordSprite.show()

