extends Control

onready var HPInitialProgress = $"HP bar background/HP Bar Initial"
onready var HPMiddleProgress = $"HP bar background/HP Bar Middle"
onready var HPFinalProgress = $"HP bar background/HP Bar Final"

onready var XPInitialProgress = $"XP bar background/XP Bar Initial"
onready var XPMiddleProgress = $"XP bar background/XP Bar Middle"
onready var XPFinalProgress = $"XP bar background/XP Bar Final"

onready var CoinAmountLabel = $"Coin Pouch background/Label"

export(int) var current_hp = 100 setget on_hp_changed
export(float) var experience_to_lvl_percent = 1 setget on_xp_changed
export(int) var coins = 10000 setget on_coins_amount_changed

onready var ItemContainer = $"Inventory/Inventory background/Item container"
onready var Inventory = $Inventory

func _ready():
	on_hp_changed(current_hp)
	on_xp_changed(experience_to_lvl_percent)
	on_coins_amount_changed(coins)
	
# warning-ignore:shadowed_variable
func on_hp_changed(current_hp):
	HPInitialProgress.value = current_hp
	HPMiddleProgress.value = current_hp
	HPFinalProgress.value = current_hp

# warning-ignore:shadowed_variable
func on_xp_changed(experience_to_lvl_percent):
	XPInitialProgress.value = experience_to_lvl_percent
	XPMiddleProgress.value = experience_to_lvl_percent
	XPFinalProgress.value = experience_to_lvl_percent

# warning-ignore:shadowed_variable
func on_coins_amount_changed(coins):
	if coins < 100000:
		CoinAmountLabel.text = str(coins)
		CoinAmountLabel.add_color_override("font_color", Color(0,0,0))
	elif coins >= 100000 and coins < 10000000:
		var coinsK = coins/1000
		CoinAmountLabel.text = str(coinsK)+("K")
		CoinAmountLabel.add_color_override("font_color", Color(0.33,0,0))
	else:
		var coinsM = coins/1000000
		CoinAmountLabel.text = str(coinsM)+("M")
		CoinAmountLabel.add_color_override("font_color", Color(0,0.33,0))

func _input(event):
	if event.is_action_pressed("open_inv") and ItemContainer.holding(null) == null:
		Inventory.visible = not Inventory.visible
	if event.is_action_pressed("ui_cancel") and ItemContainer.holding(null) == null:
		Inventory.hide()


func _on_Inventory_button_pressed():
	if ItemContainer.holding(null) == null:
		Inventory.visible = not Inventory.visible
