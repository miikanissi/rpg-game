extends Area2D


func _ready():
	pass


func _on_FishingTile_body_entered(body):
	if body.name == "Player":
		$Label.show()
		Global.can_fish = true

func _on_FishingTile_body_exited(body):
	if body.name == "Player":
		$Label.hide()
		Global.can_fish = false
		$Label.text = "Fish (space)"

func _input(event):
	if Input.is_action_just_pressed("Interact") and Global.can_fish == true:
		$Label.text = "Fishing"
		
