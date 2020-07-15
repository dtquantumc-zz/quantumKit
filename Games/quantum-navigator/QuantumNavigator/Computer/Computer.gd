extends Node2D

func create_computer_effect(toTeleport):
	var ComputerEffect = load("res://Effects/ComputerEffect.tscn")
	var computerEffect = ComputerEffect.instance()
	var world = get_tree().current_scene
	world.add_child(computerEffect)
	computerEffect.global_position = global_position
	computerEffect.connectTeleport( toTeleport )

func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.stats.pickles)
	if (_area.owner.stats.pickles >= 2):
		_area.owner.stats.pickles -= 2
		create_computer_effect(_area.owner)
		queue_free()
