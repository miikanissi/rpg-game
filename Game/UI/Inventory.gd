extends Control

func _input(event):
	if event.is_action_pressed("open_inv"):
		visible = not visible
