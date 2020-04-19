extends Node

export(Resource)var enemyScene = preload("res://Game/Enemies/Cow.tscn")
export(NodePath) var enemiesNode

onready var timer = $Timer

func _ready():
	var enemies = get_node(enemiesNode)
	var enemy = enemyScene.instance()
	enemies.add_child(enemy)
	enemy.global_position = self.global_position
	var enemyStats = enemy.get_node("EnemyStats")
	enemyStats.connect("no_health", self, "_on_no_health")

func _on_no_health():
	timer.start(15)

func _on_Timer_timeout():
	timer.stop()
	var enemies = get_node(enemiesNode)
	var enemy = enemyScene.instance()
	enemies.add_child(enemy)
	enemy.global_position = self.global_position
	var enemyStats = enemy.get_node("EnemyStats")
	enemyStats.connect("no_health", self, "_on_no_health")
