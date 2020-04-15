extends Area2D

func _on_Cave_entrance_south_body_entered(body):
	if body.name == "Player":
		var d = {"spawnpoint": "Cave spawn south"}
		var caveScene = "res://Game/Stages/Cave.tscn"
		Global.switchScene(caveScene, d)
