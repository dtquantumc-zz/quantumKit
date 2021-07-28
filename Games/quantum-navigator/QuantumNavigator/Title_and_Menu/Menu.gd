# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to the main menu object

var MenuItems = ["Start_Item", "Exit_Item", "Mute_Item"]
var Selected = 0

var MenuConfirmSound = preload("res://Title_and_Menu/MenuConfirmSound.tscn")
var MovingBetweenOptionsSound = preload("res://Title_and_Menu/MovingBetweenOptionsSound.tscn")

export(PackedScene) var startScene = null

# Called when the node enters the scene tree for the first time
# Start the music upon the title loading
func _ready():
	BackgroundMusic.start_music()

# Change selected item in the menu, and change animation states/animations
# according to which menu item was selected
func set_selection(val):
	if Selected == val: return
	get_node(MenuItems[Selected]).animation = "Static"
	get_node(MenuItems[val]).animation = "Selected"
	$Selection_Particle.position = get_node(MenuItems[val]).position - Vector2(7*8, 0)
	Selected = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Respond to keyboard input to change selected item, play sound effects
# or execute menu actions
func _process(_delta):
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

		if Selected == 0 and startScene != null:
			#get_tree().change_scene_to(startScene)
			OtterStats.set_level(2)
			get_tree().change_scene_to(load("res://Level2_Maze.tscn"))
			get_tree().change_scene_to(startScene)

			OtterStats.reset()

			
		elif Selected == 2 and startScene != null:
			if BackgroundMusic.is_playing():
				BackgroundMusic.stop_music()
			else:
				BackgroundMusic.start_music()
		else:
			get_tree().quit()
