extends TextureRect

var itemIcon;
var itemName;
var itemValue;
var itemSlot;
var slotType;
var picked = false;

var itemSize = Vector2(24,24)
func _init(_itemName, _itemTexture, _itemSlot, _itemValue, _slotType):
	self.itemName = _itemName;
	self.itemValue = _itemValue;
	self.itemSlot = _itemSlot;
	self.slotType = _slotType;
	texture = load(_itemTexture);
	mouse_filter = Control.MOUSE_FILTER_PASS;
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	picked = true;

func putItem():
	rect_position = Vector2(0, 0);
	mouse_filter = Control.MOUSE_FILTER_PASS;
	picked = false;
