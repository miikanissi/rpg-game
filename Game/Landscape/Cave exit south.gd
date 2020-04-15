extends Area2D

func _on_Cave_exit_south_body_entered(body):
	if body.name == "Player":
		var d = {"spawnpoint": "Cave spawn south"}
		var caveScene = "res://Game/Stages/World.tscn"
		Global.switchScene(caveScene, d)
