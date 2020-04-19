extends Control

onready var HPInitialProgress = $"HP bar background/HP Bar Initial"
onready var HPMiddleProgress = $"HP bar background/HP Bar Middle"
onready var HPFinalProgress = $"HP bar background/HP Bar Final"

onready var XPInitialProgress = $"XP bar background/XP Bar Initial"
onready var XPMiddleProgress = $"XP bar background/XP Bar Middle"
onready var XPFinalProgress = $"XP bar background/XP Bar Final"

onready var CoinAmountLabel = $"Coin Pouch background/Label"
onready var HPLabel = $"HP bar background/HP Label"
onready var StatLabel = $"XP bar background/Stat Label"

onready var StatIcon = $"XP bar background/Stat Icon"

var current_hp_percent = 100
var experience_to_lvl_percent = 1

const melee = preload("res://Game/UI/Icons/sword.png")
const max_hp= preload("res://Game/UI/Icons/Hp.png")
const fishing = preload("res://Game/UI/Icons/Fishing-icon.png")
const woodchopping = preload("res://Game/UI/Icons/axe.png")
const mining = preload("res://Game/UI/Icons/pickaxe.png")

var skillIcons = ["melee", "max_hp", "fishing", "woodchopping", "mining"]
onready var ItemContainer = $"Inventory/Inventory background/Item container"
onready var Inventory = $Inventory
onready var StatsPanel = $"Stats Panel"
onready var SettingsPanel = $Settings

func _ready():
	StatLabel.text = str(PlayerStats.total_level)
	current_hp_percent = (PlayerStats.cur_hp / PlayerStats.max_hp[0]) * 100
	HPLabel.text = str(PlayerStats.cur_hp)
	HPInitialProgress.value = current_hp_percent
	HPMiddleProgress.value = current_hp_percent
	HPFinalProgress.value = current_hp_percent
	CoinAmountLabel.text = str(PlayerStats.coins)

	PlayerStats.connect("experience_gained", self, "_on_experience_gained")
	PlayerStats.connect("coins_changed", self, "_on_coins_changed")
	PlayerStats.connect("hp_changed", self, "_on_hp_changed")

func _on_experience_gained(growth_data):
	for icon in skillIcons:
		if icon == growth_data[0]:
			var getIcon = get(icon)
			StatIcon.texture = getIcon
			var experience_to_lvl = growth_data[3]
			var experience = growth_data[2]
			var level = growth_data[1]
			experience_to_lvl_percent = (experience / experience_to_lvl) * 100
	
			StatLabel.text = str(level)
			XPInitialProgress.value = experience_to_lvl_percent
			XPMiddleProgress.value = experience_to_lvl_percent
			XPFinalProgress.value = experience_to_lvl_percent

func _on_hp_changed(current_hp):
	current_hp_percent = (current_hp / PlayerStats.max_hp[0]) * 100
	HPLabel.text = str(current_hp)
	HPInitialProgress.value = current_hp_percent
	HPMiddleProgress.value = current_hp_percent
	HPFinalProgress.value = current_hp_percent

func _on_coins_changed(coins):
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
		SettingsPanel.hide()
		Inventory.visible = not Inventory.visible
	if event.is_action_pressed("ui_cancel") and ItemContainer.holding(null) == null:
		Inventory.hide()
		SettingsPanel.visible = not SettingsPanel.visible
	if event.is_action_pressed("open_stats"):
		StatsPanel.visible = not StatsPanel.visible

func _on_Inventory_button_pressed():
	SettingsPanel.hide()
	if ItemContainer.holding(null) == null:
		Inventory.visible = not Inventory.visible

func _on_Skills_button_pressed():
	StatsPanel.visible = not StatsPanel.visible


func _on_Settings_button_pressed():
	Inventory.hide()
	if ItemContainer.holding(null) == null:
		SettingsPanel.visible = not SettingsPanel.visible
