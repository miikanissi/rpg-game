extends Node

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HEAD,
	SLOT_TORSO,
	SLOT_FEET,
	SLOT_LHAND,
	SLOT_RHAND
}
# assigned for areas where player is able to fish
var can_fish = false

# set getters for sceneswitching
var m_sceneParams = null setget deleted, getParams
var m_currentScene = null setget deleted
var m_player = null setget deleted
var nullify = null

# save path for player data as json
const SAVE_PATH = "user://save.json"

# error checking
func deleted(_m_sceneParams):
	assert(false)

func _ready():
	# Load game loading player in the correct scene
	load_game()
	

func switchScene(targetScenePath, params = null):
	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	call_deferred("deferredSwitchScene", targetScenePath, params)


func deferredSwitchScene(targetScenePath, params):
	if targetScenePath == null:
		return
	
	# Can't make dictionary null using m_sceneParams = null, but assigning
	# m_sceneParams a variable which value is null works
	m_sceneParams = nullify
	
	# Makes sure m_sceneParams are empty before assigning it
	# new parameters. 
	# This way parameters can be a dictionary or any other variable interchangably
	assert(m_sceneParams == null)
	m_sceneParams = params
	
	# Gets player from the player group and assigns it as m_player (store it in memory)
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		m_player = player
	
	# Gets the parent of player and removes player from the scene
	var root = get_tree().get_root()
	var game = root.get_child( root.get_child_count() -1 )
	var ysort = m_currentScene.get_child(m_currentScene.get_child_count() -1)
	ysort.remove_child(m_player)

	# Free the old scene
	m_currentScene.free()

	# Load new scene
	var newScene = ResourceLoader.load(targetScenePath)

	# Instance the new scene
	m_currentScene = newScene.instance()
	
	# Add it to the active scene, as child of current scene and move it to the bottom of the scene
	game.add_child(m_currentScene)
	game.move_child(m_currentScene, 0)
	
	# Get the scenes YSort node and add player there as a child
	var ysorted = m_currentScene.get_child(m_currentScene.get_child_count() -1)
	ysorted.add_child(m_player)
	
	# Get spawnpoints under "Spawnpoints node"
	var spawnpoints = m_currentScene.get_node("Spawnpoints")
	
	# Get spawnpoint specified in params by name
	var spawnpoint = spawnpoints.get_node(m_sceneParams.get("spawnpoint"))
	
	# Make player position spawnpoint
	m_player.position = spawnpoint.get_position()
	

# Gets parameters given upon scene change
func getParams():
	var params = m_sceneParams
	m_sceneParams = nullify
	return params


"""
Saves and loads savegame files
Each node is responsible for finding itself in the save_game
dict so saves don't rely on the nodes' path or their source file
"""
func save_game():
	# Saves player node as dictionary with values from player node
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group("Player")
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	# Saves dictionary as json in defined save path
	print (save_dict) # Debugging
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_line(to_json(save_dict))
	
	save_file.close()

func load_game():
	# Upon loading game first loads all scenes present in the game
	# Defines default world and default location for player
	# Then removes player
	var save_file = File.new()
	var root = get_tree().get_root()
	var game = root.get_child( root.get_child_count() -1 )
	m_player = game.get_child(game.get_child_count() -1)
	m_currentScene = game.get_child(game.get_child_count() -2)
	game.remove_child(m_player)
	
	# Gets all stages from stages group, currently includes World and Cave
	var stages = get_tree().get_nodes_in_group("Stages")
	
	# If save file does not exist this loads default world and default player position and stats
	# And removes other scenes.
	if not save_file.file_exists(SAVE_PATH):
		for stage in stages:
			game.remove_child(stage)
		game.add_child(m_currentScene)
		var ysorted = m_currentScene.get_child(m_currentScene.get_child_count() -1)
		ysorted.add_child(m_player)
		var spawnpoints = m_currentScene.get_node("Spawnpoints")
		var mainspawn = spawnpoints.get_node("Main spawn")
		m_player.position = mainspawn.get_position()
		return
	
	# If save file is found this starts parsing the data
	save_file.open(SAVE_PATH, File.READ)
	var data = parse_json(save_file.get_as_text())
	
	for node_path in data.keys():
		
		# Goes through each stage adding player into YSort node and checking if previous
		# save was done in the location in the scene tree.
		# If previous save was done in that stage adds that stage as current scene
		# Not the best implementation needs refactoring but works as intended.
		for stage in stages:
			var ysorted = stage.get_child(stage.get_child_count() -1)
			ysorted.add_child(m_player)
			var node = has_node(node_path)
			if not node:
				ysorted.remove_child(m_player)
				game.remove_child(stage)
			else:
				m_currentScene = stage
				ysorted.remove_child(m_player)
				game.remove_child(stage)
				m_currentScene = stage

		# Adds the current scene defined by previous loop into the game tree
		game.add_child(m_currentScene)
		var ysort = m_currentScene.get_child(m_currentScene.get_child_count() -1)
		ysort.add_child(m_player)
		
		# Loads players data (stats, position) and adds them to player
		var node = get_node(node_path)
		for attribute in data[node_path]:
			if attribute == "pos":
				node.set_position(Vector2(data[node_path]["pos"]["x"], data[node_path]["pos"]["y"]))
			else:
				node.set(attribute, data[node_path][attribute])
				
