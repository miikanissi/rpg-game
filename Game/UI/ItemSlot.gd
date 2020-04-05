extends Panel

export(Global.SlotType) var slotType = Global.SlotType.SLOT_DEFAULT;

var slotIndex;
var item = null;
var style;
var itemSize = Vector2(20,20)

# Initializes the style for itemslots
func _init():
	mouse_filter = Control.MOUSE_FILTER_PASS;
	rect_min_size = Vector2(28, 28);
	style = StyleBoxFlat.new();
	style.set_border_width_all(2);
	set('custom_styles/panel', style);

# Called to create a new item
func setItem(newItem):
	newItem.rect_min_size=itemSize
	newItem.rect_position=Vector2(4, 4)
	newItem.expand=true
	newItem.stretch_mode=6

	add_child(newItem);
	item = newItem;
	item.itemSlot = self;
# Called when item is picked up from inventory
func pickItem():
	item.pickItem();
	remove_child(item);
	var inventory = get_tree().get_root().get_node("Game/InventoryLayer/Inventory")
	inventory.add_child(item);
	item = null;

# Called when item is put into inventory or character panel
func putItem(newItem):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	item.rect_position=Vector2(4, 4)
	var inventory = get_tree().get_root().get_node("Game/InventoryLayer/Inventory")
	inventory.remove_child(item)
	add_child(item);

# Called when item wants to be removed
func removeItem():
	remove_child(item);
	item = null;

# Called when equipping an item either by dragging or right clicking
func equipItem(newItem, rightClick =  true):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	item.rect_position=Vector2(4, 4)
	if !rightClick:
		var inventory = get_tree().get_root().get_node("Game/InventoryLayer/Inventory")
		inventory.remove_child(item);
	add_child(item);
