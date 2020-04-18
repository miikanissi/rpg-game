extends TextureRect

var itemIcon;
var itemName;
var itemValue;
var itemSlot;
var slotType;
var stackable;
var itemCount;
var picked = false;
var label = Label.new()

var itemSize = Vector2(24,24)
func _init(_itemName, _itemTexture, _itemSlot, _itemValue, _slotType, _stackable, _itemCount):
	self.itemName = _itemName;
	self.itemValue = _itemValue;
	self.itemSlot = _itemSlot;
	self.slotType = _slotType;
	self.stackable = _stackable;
	self.itemCount = _itemCount;
	texture = load(_itemTexture);
	mouse_filter = Control.MOUSE_FILTER_PASS;
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;

func updateCounter():
	if !label.text:
		label.text = str(self.itemCount)
		label.add_color_override("font_color", Color(1,0,0))
		add_child(label)
	else:
		label.text = str(self.itemCount)

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	picked = true;

func putItem():
	rect_position = Vector2(0, 0);
	mouse_filter = Control.MOUSE_FILTER_PASS;
	picked = false;
