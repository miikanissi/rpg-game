extends Area2D

func _on_Cave_entrance_body_entered(body):
	if body.name == "Player":
		var d = {"spawnpoint": "Cave spawn north"}
		var caveScene = "res://Game/Stages/Cave.tscn"
		Global.switchScene(caveScene, d)
