extends Area2D

func _on_Cave_exit_north_body_entered(body):
	if body.name == "Player":
		var d = {"spawnpoint": "Cave spawn north"}
		var caveScene = "res://Game/Stages/World.tscn"
		Global.switchScene(caveScene, d)
