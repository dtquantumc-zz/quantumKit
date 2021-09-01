# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to global open dialogue info state object
# Determines if various info boxes are currently open
# Note: unusued duplicate res://World/InfoDialogOpenState.gd exists

signal game_intro_dialog_open(value)
signal bell_pair_dialog_open(value)
signal teleporter_dialog_open(value)
signal encoder_dialog_open(value)
signal decoder_dialog_open(value)
signal fire_trap_dialog_open(value)
signal superposition_dialog_open(value)
signal key_dialog_open(value)

var is_game_intro_dialog_open : bool = false setget set_is_game_intro_dialog_open, get_is_game_intro_dialog_open
var is_bell_pair_dialog_open : bool = false setget set_is_bell_pair_dialog_open, get_is_bell_pair_dialog_open
var is_teleporter_dialog_open : bool = false setget set_is_teleporter_dialog_open, get_is_teleporter_dialog_open
var is_encoder_dialog_open : bool = false setget set_is_encoder_dialog_open, get_is_encoder_dialog_open
var is_decoder_dialog_open : bool = false setget set_is_decoder_dialog_open, get_is_decoder_dialog_open
var is_fire_trap_dialog_open : bool = false setget set_is_fire_trap_dialog_open, get_is_fire_trap_dialog_open
var is_superposition_dialog_open: bool = false setget set_is_superposition_dialog_open, get_is_superposition_dialog_open
var is_key_dialog_open: bool = false setget set_is_key_dialog_open, get_is_key_dialog_open

func set_is_game_intro_dialog_open(value : bool):
	is_game_intro_dialog_open = value

func set_is_bell_pair_dialog_open(value : bool):
	is_bell_pair_dialog_open = value

func set_is_teleporter_dialog_open(value : bool):
	is_teleporter_dialog_open = value

func set_is_encoder_dialog_open(value : bool):
	is_encoder_dialog_open = value

func set_is_decoder_dialog_open(value : bool):
	is_decoder_dialog_open = value

func set_is_fire_trap_dialog_open(value : bool):
	is_fire_trap_dialog_open = value

func set_is_superposition_dialog_open(value: bool):
	is_superposition_dialog_open = value
	
func set_is_key_dialog_open(value: bool):
	is_key_dialog_open = value
	
func get_is_game_intro_dialog_open() -> bool:
	return is_game_intro_dialog_open

func get_is_bell_pair_dialog_open() -> bool:
	return is_bell_pair_dialog_open

func get_is_teleporter_dialog_open() -> bool:
	return is_teleporter_dialog_open

func get_is_encoder_dialog_open() -> bool:
	return is_encoder_dialog_open

func get_is_decoder_dialog_open() -> bool:
	return is_decoder_dialog_open

func get_is_fire_trap_dialog_open() -> bool:
	return is_fire_trap_dialog_open

func get_is_superposition_dialog_open() -> bool:
	return is_superposition_dialog_open
	
func get_is_key_dialog_open() -> bool:
	return is_key_dialog_open
	
func get_is_info_dialog_open() -> bool:
	return (get_is_game_intro_dialog_open() ||
		get_is_bell_pair_dialog_open() ||
		get_is_teleporter_dialog_open() ||
		get_is_encoder_dialog_open() ||
		get_is_decoder_dialog_open() ||
		get_is_fire_trap_dialog_open() ||
		get_is_superposition_dialog_open() ||
		get_is_key_dialog_open())

func _ready():
	# warning-ignore:return_value_discarded
	connect("game_intro_dialog_open", self, "set_is_game_intro_dialog_open")
	# warning-ignore:return_value_discarded
	connect("bell_pair_dialog_open", self, "set_is_bell_pair_dialog_open")
	# warning-ignore:return_value_discarded
	connect("teleporter_dialog_open", self, "set_is_teleporter_dialog_open")
	# warning-ignore:return_value_discarded
	connect("encoder_dialog_open", self, "set_is_encoder_dialog_open")
	# warning-ignore:return_value_discarded
	connect("decoder_dialog_open", self, "set_is_decoder_dialog_open")
	# warning-ignore:return_value_discarded
	connect("fire_trap_dialog_open", self, "set_is_fire_trap_dialog_open")
	connect("superposition_dialog_open", self, "set_is_superposition_dialog_open")
	connect("key_dialog_open", self, "set_is_key_dialog_open")
