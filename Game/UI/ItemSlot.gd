extends Panel

export(Global.SlotType) var slotType = Global.SlotType.SLOT_DEFAULT;

var slotIndex;
var item = null;
var style;

func _init():
	mouse_filter = Control.MOUSE_FILTER_PASS;
	rect_min_size = Vector2(34, 34);
	style = StyleBoxFlat.new();
	style.set_border_width_all(2);
	set('custom_styles/panel', style);

func setItem(newItem):
	add_child(newItem);
	item = newItem;
	item.itemSlot = self;

func pickItem():
	item.pickItem();
	remove_child(item);
	get_tree().get_root().add_child(item);
	item = null;

func putItem(newItem):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	get_tree().get_root().remove_child(item);
	add_child(item);

func removeItem():
	remove_child(item);
	item = null;

func equipItem(newItem, rightClick =  true):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	if !rightClick:
		get_tree().get_root().remove_child(item);
	add_child(item);
