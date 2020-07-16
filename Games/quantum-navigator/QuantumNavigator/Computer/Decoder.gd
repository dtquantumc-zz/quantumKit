extends Node2D
func create_decoder_effect(toTeleport):
	var DecoderEffect = load("res://Effects/DecoderEffect.tscn")
	var decoderEffect = DecoderEffect.instance()
	var world = get_tree().current_scene
	world.add_child(decoderEffect)
	decoderEffect.global_position = global_position
	decoderEffect.connectTeleport( toTeleport )

func _on_Hurtbox_area_entered(_area):
#	print(_area.owner.followers)
	if (_area.owner.followers.size() >= 1 and _area.owner.stats.isEncoded):
		create_decoder_effect(_area.owner)
		queue_free()
