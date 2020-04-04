extends NinePatchRect

const ItemClass = preload("res://Game/UI/ItemBase.gd");
const ItemSlotClass = preload("res://Game/UI/ItemSlot.gd");
const MAX_SLOTS = 45;

var slotList = Array();

var holdingItem = null;
var itemOffset = Vector2(0, 0);

onready var characterPanel = get_node("../../Character background/Character container")

func _ready():
	var slots = get_node("SlotsContainer/Slots");
	for _i in range(MAX_SLOTS):
		var slot = ItemSlotClass.new();
		slot.connect("mouse_entered", self, "mouse_enter_slot", [slot]);
		slot.connect("mouse_exited", self, "mouse_exit_slot", [slot]);
		slot.connect("gui_input", self, "slot_gui_input", [slot]);
		slotList.append(slot);
		slots.add_child(slot);
	
	for i in range(characterPanel.get_child_count()):
		var panelSlot = characterPanel.get_child(i);
		if panelSlot:
			panelSlot.connect("mouse_entered", self, "mouse_enter_slot", [panelSlot]);
			panelSlot.connect("mouse_exited", self, "mouse_exit_slot", [panelSlot]);
			panelSlot.connect("gui_input", self, "slot_gui_input", [panelSlot]);
	
	pickup_item("axe")
	pickup_item("pickaxe")
	pickup_item("sapphire")
	pickup_item("amethyst")
	pickup_item("axe")
	
func mouse_enter_slot(_slot : ItemSlotClass):
	if _slot.item:
		pass
		#tooltip.display(_slot.item, get_global_mouse_position());

func mouse_exit_slot(_slot : ItemSlotClass):
	pass
	#if tooltip.visible:
	#	tooltip.hide();

func slot_gui_input(event : InputEvent, slot : ItemSlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holdingItem:
				if slot.slotType != Global.SlotType.SLOT_DEFAULT:
					if canEquip(holdingItem, slot):
						if !slot.item:
							slot.equipItem(holdingItem, false);
							holdingItem = null;
						else:
							var tempItem = slot.item;
							slot.pickItem();
							tempItem.rect_global_position = event.global_position - itemOffset;
							slot.equipItem(holdingItem, false);
							holdingItem = tempItem;
				elif slot.item:
					var tempItem = slot.item;
					slot.pickItem();
					tempItem.rect_global_position = event.global_position - itemOffset;
					slot.putItem(holdingItem);
					holdingItem = tempItem;
				else:
					slot.putItem(holdingItem);
					holdingItem = null;
			elif slot.item:
				holdingItem = slot.item;
				itemOffset = event.global_position - holdingItem.rect_global_position;
				slot.pickItem();
				holdingItem.rect_global_position = event.global_position - itemOffset;
		elif event.button_index == BUTTON_RIGHT && !event.pressed:
			if slot.slotType != Global.SlotType.SLOT_DEFAULT:
				if slot.item:
					var freeSlot = getFreeSlot();
					if freeSlot:
						var item = slot.item;
						slot.removeItem();
						freeSlot.setItem(item);
			else:
				if slot.item:
					var itemSlotType = slot.item.slotType;
					var panelSlot = characterPanel.getSlotByType(slot.item.slotType);
					if itemSlotType == Global.SlotType.SLOT_RING:
						if panelSlot[0].item && panelSlot[1].item:
							var panelItem = panelSlot[0].item;
							panelSlot[0].removeItem();
							var slotItem = slot.item;
							slot.removeItem();
							slot.setItem(panelItem);
							panelSlot[0].setItem(slotItem);
							pass
						elif !panelSlot[0].item && panelSlot[1].item || !panelSlot[0].item && !panelSlot[1].item:
							var tempItem = slot.item;
							slot.removeItem();
							panelSlot[0].equipItem(tempItem);
						elif panelSlot[0].item && !panelSlot[1].item:
							var tempItem = slot.item;
							slot.removeItem();
							panelSlot[1].equipItem(tempItem);
							pass
					else:
						if panelSlot.item:
							var panelItem = panelSlot.item;
							panelSlot.removeItem();
							var slotItem = slot.item;
							slot.removeItem();
							slot.setItem(panelItem);
							panelSlot.setItem(slotItem);
						else:
							var tempItem = slot.item;
							slot.removeItem();
							panelSlot.equipItem(tempItem);

func _input(event : InputEvent):
	if holdingItem && holdingItem.picked:
		holdingItem.rect_global_position = event.global_position - itemOffset;

func getFreeSlot():
	for slot in slotList:
		if !slot.item:
			return slot;

func canEquip(item, slot):
	return item.slotType == slot.slotType

func pickup_item(item_id):
	var slot = getFreeSlot()
	if slot:
		var itemName = ItemDb.get_item(item_id)["itemName"]
		var itemIcon = ItemDb.get_item(item_id)["itemIcon"]
		var itemValue = ItemDb.get_item(item_id)["itemValue"]
		var slotType = ItemDb.get_item(item_id)["slotType"]
		slot.setItem(ItemClass.new(itemName, itemIcon, null, itemValue, slotType));
