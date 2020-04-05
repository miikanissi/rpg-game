extends Node

const ICON_PATH = "res://Game/UI/Icons/"
const ITEMS = {
	"axe": {
		"itemName": "Axe",
		"itemValue": 100,
		"itemIcon": ICON_PATH + "axe.png",
		"slotType": Global.SlotType.SLOT_RHAND,
		"stackable": false,
	},
	"pickaxe": {
		"itemName": "Pickaxe",
		"itemValue": 100,
		"itemIcon": ICON_PATH + "pickaxe.png",
		"slotType": Global.SlotType.SLOT_RHAND,
		"stackable": false,
	},
	"sapphire": {
		"itemName": "Sapphire",
		"itemValue": 1000,
		"itemIcon": ICON_PATH + "sapphire.png",
		"slotType": Global.SlotType.SLOT_DEFAULT,
		"stackable": true,
	},
	"amethyst": {
		"itemName": "Amethyst",
		"itemValue": 2000,
		"itemIcon": ICON_PATH + "amethyst.png",
		"slotType": Global.SlotType.SLOT_DEFAULT,
		"stackable": true,
	},
	"error": {
		"itemName": "Error",
		"itemValue": 0,
		"itemIcon": ICON_PATH + "error.png",
		"slotType": Global.SlotType.SLOT_DEFAULT,
		"stackable": true,
	}
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
