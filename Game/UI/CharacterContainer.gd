extends NinePatchRect

var slots = Array();

func _ready():
	slots.resize(512);
	slots.insert(Global.SlotType.SLOT_HEAD, get_node("SlotHead"));
	slots.insert(Global.SlotType.SLOT_TORSO, get_node("SlotTorso"));
	slots.insert(Global.SlotType.SLOT_LEGS, get_node("SlotLegs"));
	slots.insert(Global.SlotType.SLOT_FEET, get_node("SlotFeet"));
	slots.insert(Global.SlotType.SLOT_LHAND, get_node("SlotLHand"));
	slots.insert(Global.SlotType.SLOT_RHAND, get_node("SlotRHand"));

func getSlotByType(type):
	return slots[type];

func getItemByType(type):
	return slots[type].item;
