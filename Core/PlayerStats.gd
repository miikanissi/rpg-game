extends Node

signal experience_gained(growth_data)
signal coins_changed(coins)
signal hp_changed(cur_hp)
signal level_gained()

# CHARACTER STATS [Level, Total Experience, Current Level Experience]
export(Array,int) var max_hp = [10, 1189, 0]
export(int) var cur_hp = max_hp[0]
export(Array,int) var melee = [1, 0, 0]
export(Array,int) var woodchopping = [1, 0, 0]
export(Array,int) var fishing = [1, 0, 0]
export(Array,int) var mining = [1, 0, 0]

export (int) var damage = round(pow(melee[0], 0.7))
export(Array) var growth_data = []
var stats= ['max_hp', 'melee', 'woodchopping', 'fishing', 'mining']

export (int) var coins = 100
# LEVELING SYSTEM

var experience_total = 1189
var total_level = 14
func _ready():
	add_to_group("Save")

func gain_hp(amount):
	if cur_hp + amount > max_hp[0]:
		cur_hp = max_hp[0]
		emit_signal("hp_changed", cur_hp)
	else:
		cur_hp += amount
		emit_signal("hp_changed", cur_hp)

func lose_hp(amount):
	cur_hp -= amount
	emit_signal("hp_changed", cur_hp)

func give_coins(amount):
	coins += amount
	emit_signal("coins_changed", coins)

func take_coins(amount):
	coins -= amount
	emit_signal("coins_changed", coins)

func get_required_experience(level):
	return round(abs(level - 1 + (300 * pow(2,((level-1)/7)))/4))

func gain_experience(amount, statName):
	for stat in stats:
		if stat == statName:
			experience_total += amount
			var getStat = get(stat)
			var experience_required = get_required_experience(getStat[0] + 1)
			getStat[1] += amount
			getStat[2] += amount
			while getStat[2] >= experience_required:
				getStat[2] -= experience_required
				getStat[0] += 1
				total_level += 1
				experience_required = get_required_experience(getStat[0] + 1)
				emit_signal("level_gained")
			if statName == "strength":
				damage = round(pow(getStat[0], 0.7))
			growth_data = [statName, getStat[0], getStat[2], experience_required]
			emit_signal("experience_gained", growth_data)

func save():
	var save_dict = {
		experience_total = experience_total,
		total_level = total_level,
		max_hp = max_hp,
		cur_hp = cur_hp,
		melee = melee,
		fishing = fishing,
		woodchopping = woodchopping,
		mining = mining,
		coins = coins,
	}
	return save_dict
