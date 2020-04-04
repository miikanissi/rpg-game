extends Control

func _input(event):
	if event.is_action_pressed("open_inv"):
		get_tree().paused = not get_tree().paused
		visible = not visible
