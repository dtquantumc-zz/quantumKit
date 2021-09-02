# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to a menu that has the option to load a save game

var MenuItems : Array = ["LoadGame_Item", "NewGame_Item", "Exit_Item", "Mute_Item"]
var Selected : int = 0

const MenuConfirmSound : PackedScene = preload("res://Title_and_Menu/MenuConfirmSound.tscn")
const MovingBetweenOptionsSound : PackedScene = preload("res://Title_and_Menu/MovingBetweenOptionsSound.tscn")

export(PackedScene) var startScene : PackedScene = null

# Called when the node enters the scene tree for the first time.
# Starts the background music
func _ready():
	BackgroundMusic.start_music()

# Sets the selected menu item
func set_selection(val: int):
	if Selected == val: return
	get_node(MenuItems[Selected]).animation = "Static"
	get_node(MenuItems[val]).animation = "Selected"
	$Selection_Particle.position = get_node(MenuItems[val]).position - Vector2(7*8, 0)
	Selected = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Handles keyboard inputs every frame - adjusts selected item and plays
# appropriate sound effects
func _process(_delta):
	var newselect : int = Selected
	if Input.is_action_just_pressed("ui_up"):
		newselect -= 1
		newselect += MenuItems.size()
		newselect %= MenuItems.size()

		var movingBetweenOptionsSound = MovingBetweenOptionsSound.instance()
		get_parent().add_child(movingBetweenOptionsSound)

	if Input.is_action_just_pressed("ui_down"):
		newselect += 1
		newselect %= MenuItems.size()

		var movingBetweenOptionsSound = MovingBetweenOptionsSound.instance()
		get_parent().add_child(movingBetweenOptionsSound)

	set_selection(newselect)
	if Input.is_action_just_pressed("ui_accept"):
		var menuConfirmSound = MenuConfirmSound.instance()
		get_parent().add_child(menuConfirmSound)
		
		if Selected == 0:
			_load_game()
		elif Selected == 1 and startScene != null:
			_new_game()
		elif Selected == 3 and startScene != null:
			_toggle_audio()
		else:
			get_tree().quit()

# Sets up game based on save data, creates new game if data or format is invalid
func _load_game():
	var save_data = SaveManager.load_progress()
	print(save_data)
	if !SaveManager.validate_save_data(save_data):
		print("Save file is invalid, starting a new game")
		_new_game()
		return
	print(save_data)
	get_tree().change_scene(save_data["level_scene"])
	OtterStats.reset()
	OtterStats.set_level(int(save_data["level_number"]))
	# Hm... is this supposed to be temporary?
	#			|
	#			|
	#			|
	#		   \  /
	#			\/
	#OtterStats.set_level(4)
	#get_tree().change_scene_to(load("res://GodotCredits.tscn"))
	
# Starts a new game
func _new_game():
	var dir = Directory.new()
	dir.remove(SaveManager.save_path)
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(startScene)
	OtterStats.reset()
	OtterStats.set_level(1)

# Stops the background music if it is playing, starts it if it is not
func _toggle_audio():
	if BackgroundMusic.is_playing():
		BackgroundMusic.stop_music()
	else:
		BackgroundMusic.start_music()
