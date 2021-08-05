# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

var MenuItems = ["LoadGame_Item", "NewGame_Item", "Exit_Item", "Mute_Item"]
var Selected = 0

var MenuConfirmSound = preload("res://Title_and_Menu/MenuConfirmSound.tscn")
var MovingBetweenOptionsSound = preload("res://Title_and_Menu/MovingBetweenOptionsSound.tscn")

export(PackedScene) var startScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundMusic.start_music()

func set_selection(val):
	if Selected == val: return
	get_node(MenuItems[Selected]).animation = "Static"
	get_node(MenuItems[val]).animation = "Selected"
	$Selection_Particle.position = get_node(MenuItems[val]).position - Vector2(7*8, 0)
	Selected = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var newselect = Selected
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
			_mute_audio()
		else:
			get_tree().quit()

#Sets up game based on save data, creates new game if data or format is invalid
func _load_game():
	var save_data = SaveManager.load_progress()
	if !SaveManager.validate_save_data(save_data):
		print("Save file is invalid, starting a new game")
		_new_game()
		return
	get_tree().change_scene(save_data["level_scene"])
	OtterStats.reset()
	OtterStats.set_level(save_data["level_number"])
	
	#OtterStats.set_level(2)
	#get_tree().change_scene_to(load("res://Level2_Maze.tscn"))
	
func _new_game():
	var dir = Directory.new()
	dir.remove(SaveManager.save_path)
	get_tree().change_scene_to(startScene)
	OtterStats.reset()
	OtterStats.set_level(1)
	
func _mute_audio():
	if BackgroundMusic.is_playing():
		BackgroundMusic.stop_music()
	else:
		BackgroundMusic.start_music()
