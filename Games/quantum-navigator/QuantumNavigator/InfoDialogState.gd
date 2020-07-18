extends Node2D

var has_bell_pair_dialog_been_seen = false setget set_has_bell_pair_dialog_been_seen, get_has_bell_pair_dialog_been_seen
var has_teleporter_dialog_been_seen = false setget set_has_teleporter_dialog_been_seen, get_has_teleporter_dialog_been_seen
var has_encoder_dialog_been_seen = false setget set_has_encoder_dialog_been_seen, get_has_encoder_dialog_been_seen
var has_decoder_dialog_been_seen = false setget set_has_decoder_dialog_been_seen, get_has_decoder_dialog_been_seen
var has_fire_trap_dialog_been_seen = false setget set_has_fire_trap_dialog_been_seen, get_has_fire_trap_dialog_been_seen

func set_has_bell_pair_dialog_been_seen(value):
	has_bell_pair_dialog_been_seen = value

func set_has_teleporter_dialog_been_seen(value):
	has_teleporter_dialog_been_seen = value

func set_has_encoder_dialog_been_seen(value):
	has_encoder_dialog_been_seen = value

func set_has_decoder_dialog_been_seen(value):
	has_decoder_dialog_been_seen = value

func set_has_fire_trap_dialog_been_seen(value):
	has_fire_trap_dialog_been_seen = value

func get_has_bell_pair_dialog_been_seen():
	return has_bell_pair_dialog_been_seen

func get_has_teleporter_dialog_been_seen():
	return has_teleporter_dialog_been_seen

func get_has_encoder_dialog_been_seen():
	return has_encoder_dialog_been_seen

func get_has_decoder_dialog_been_seen():
	return has_decoder_dialog_been_seen

func get_has_fire_trap_dialog_been_seen():
	return has_fire_trap_dialog_been_seen
