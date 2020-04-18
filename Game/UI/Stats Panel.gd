extends Control

onready var HpLabel = $"Background/Stats Container/GridContainer/Hp/Label"
onready var MeleeLabel = $"Background/Stats Container/GridContainer/Melee/Label"
onready var FishingLabel = $"Background/Stats Container/GridContainer/Fishing/Label"
onready var WoodchoppingLabel = $"Background/Stats Container/GridContainer/Woodchopping/Label"
onready var MiningLabel = $"Background/Stats Container/GridContainer/Mining/Label"
onready var TotalLabel = $"Background/Stats Container/GridContainer/Total/Label"

func _ready():
	PlayerStats.connect("level_gained", self, "_on_level_gained")
	HpLabel.text = str(PlayerStats.max_hp[0])
	MeleeLabel.text = str(PlayerStats.melee[0])
	FishingLabel.text = str(PlayerStats.fishing[0])
	WoodchoppingLabel.text = str(PlayerStats.woodchopping[0])
	MiningLabel.text = str(PlayerStats.mining[0])
	TotalLabel.text = str(PlayerStats.total_level)

func _on_level_gained():
	HpLabel.text = str(PlayerStats.max_hp[0])
	MeleeLabel.text = str(PlayerStats.melee[0])
	FishingLabel.text = str(PlayerStats.fishing[0])
	WoodchoppingLabel.text = str(PlayerStats.woodchopping[0])
	MiningLabel.text = str(PlayerStats.mining[0])
	TotalLabel.text = str(PlayerStats.total_level)
