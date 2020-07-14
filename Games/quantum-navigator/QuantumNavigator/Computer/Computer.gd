extends Node2D



func create_computer_effect():
	var ComputerEffect = load("res://Effects/ComputerEffect.tscn")
	var computerEffect = ComputerEffect.instance()
	var world = get_tree().current_scene
	world.add_child(computerEffect)
	computerEffect.global_position = global_position
	print("test")

func _on_Hurtbox_area_entered(_area):
	if ($'/root/World/YSort/Otter'.stats.pickles >= 2):
		$'/root/World/YSort/Otter'.stats.pickles -= 2
		create_computer_effect()
		queue_free()

