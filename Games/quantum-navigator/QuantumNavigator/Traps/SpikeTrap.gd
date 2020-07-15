extends Node2D

func create_spike_effect():
	var SpikeEffect = load("res://Effects/SpikeEffect.tscn")
	var spikeEffect = SpikeEffect.instance()
	var world = get_tree().current_scene
	world.add_child(spikeEffect)
	spikeEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	create_spike_effect()
	queue_free()


func _on_Hurtbox_area_exited(area):
	create_spike_effect()
	queue_free()
