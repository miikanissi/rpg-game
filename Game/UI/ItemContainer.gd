extends NinePatchRect

const ItemClass = preload("res://Game/UI/ItemBase.gd");
const ItemSlotClass = preload("res://Game/UI/ItemSlot.gd");
const MAX_SLOTS = 44;

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
	
	for i in Global.loadInventory:
		for count in range(i.itemcount):
			pickup_item(i.name.to_lower(), i.position)
	for i in Global.loadEquipment:
		var slot : ItemSlotClass
		equip_item(i, slot)
		#var axe = pickup_item(i)
		#equip_item(i, slot : ItemSlotClass)
	
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
				save()
				holdingItem = slot.item
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
					var panelSlot = characterPanel.getSlotByType(itemSlotType);
					if panelSlot == null:
						pass
					elif panelSlot.item:
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

# Called for every input
func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		if holdingItem && holdingItem.picked:
			holdingItem.rect_global_position = get_global_mouse_position() - itemOffset;

func getSlot(position):
	var counter = 1
	for slot in slotList:
		if counter == position:
			if !slot.item:
				return slot;
			else:
				position += 1
		counter += 1
		
# Gets the closest free slot
func getFreeSlot():
	for slot in slotList:
		if !slot.item:
			return slot;

func checkItemExist(newItemName):
	# Goes through all slots in inventory
	for slot in slotList:
		# If slot has an item checks if that item is same as new item
		if slot.item:
			var itemNameSlot = slot.item.itemName;
			if itemNameSlot == newItemName:
				slot.item.itemCount += 1
				slot.item.updateCounter()
				return true
# Checks if the items slot type is the same as slots type
func canEquip(item, slot):
	return item.slotType == slot.slotType

# Called when picking up an item
# item_id is the id in database
func pickup_item(item_id, position):#, slot):
	var slot
	if !position:
		slot = getFreeSlot()
	else:
		slot = getSlot(position)
	var itemName = ItemDb.get_item(item_id)["itemName"]
	var stackable = ItemDb.get_item(item_id)["stackable"]
	# checks if item picked up is stackable and if it already exists
	if stackable and checkItemExist(itemName):
		pass
		
	else:
		var itemIcon = ItemDb.get_item(item_id)["itemIcon"]
		var itemValue = ItemDb.get_item(item_id)["itemValue"]
		var slotType = ItemDb.get_item(item_id)["slotType"]
		if slot:
			slot.setItem(ItemClass.new(itemName, itemIcon, null, itemValue, slotType, stackable, 1));

func equip_item(item_id, slot :ItemSlotClass):
	var itemName = ItemDb.get_item(item_id)["itemName"]
	var stackable = ItemDb.get_item(item_id)["stackable"]
	var itemIcon = ItemDb.get_item(item_id)["itemIcon"]
	var itemValue = ItemDb.get_item(item_id)["itemValue"]
	var slotType = ItemDb.get_item(item_id)["slotType"]
	
	for i in range(characterPanel.get_child_count()):
		var panelSlot = characterPanel.get_child(i);
		if panelSlot.slotType == slotType:
			panelSlot.setItem(ItemClass.new(itemName, itemIcon, null, itemValue, slotType, stackable, 1));
	
func save():
	var save_dict = {}
	var inventory_dict = {}
	var character_dict = {}
	var counter = 0
	for slot in slotList:
		counter += 1
		if slot.item:
			var item_dict = {}
			
			item_dict["name"] = slot.item.itemName
			item_dict["position"] = counter
			item_dict["itemcount"] = slot.item.itemCount
			inventory_dict["item" + str(counter)] = item_dict
			
	
	var panelSlotList = characterPanel.get_children()
	for slot in panelSlotList:
		if slot.item == null:
			pass
		else:
			character_dict[slot.item.itemName] = slot.item.slotType
	save_dict["inventory"] = inventory_dict
	save_dict["equipment"] = character_dict
	return save_dict
