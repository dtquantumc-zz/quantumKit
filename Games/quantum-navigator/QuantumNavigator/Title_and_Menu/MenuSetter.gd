extends Node

# Script that determines which menu to use based on whether or not a save file exists

export(NodePath) var menuNoSaveExists
export(NodePath) var menuSaveExists

# Called when the node enters the scene tree for the first time.
# Deletes the correct menu upon locating/not locating a save game
func _ready():
	assert(menuNoSaveExists != null)
	assert(menuSaveExists != null)
	
	if (SaveManager.load_progress() == null):
		get_node(menuSaveExists).queue_free()
	else:
		get_node(menuNoSaveExists).queue_free()
