# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Unused script: duplicate of res://InfoDialogOpenState.gd

var is_game_intro_dialog_open = false setget set_is_game_intro_dialog_open, get_is_game_intro_dialog_open
var is_bell_pair_dialog_open = false setget set_is_bell_pair_dialog_open, get_is_bell_pair_dialog_open
var is_teleporter_dialog_open = false setget set_is_teleporter_dialog_open, get_is_teleporter_dialog_open
var is_encoder_dialog_open = false setget set_is_encoder_dialog_open, get_is_encoder_dialog_open
var is_decoder_dialog_open = false setget set_is_decoder_dialog_open, get_is_decoder_dialog_open
var is_fire_trap_dialog_open = false setget set_is_fire_trap_dialog_open, get_is_fire_trap_dialog_open

func set_is_game_intro_dialog_open(value):
	is_game_intro_dialog_open = value

func set_is_bell_pair_dialog_open(value):
	is_bell_pair_dialog_open = value

func set_is_teleporter_dialog_open(value):
	is_teleporter_dialog_open = value

func set_is_encoder_dialog_open(value):
	is_encoder_dialog_open = value

func set_is_decoder_dialog_open(value):
	is_decoder_dialog_open = value

func set_is_fire_trap_dialog_open(value):
	is_fire_trap_dialog_open = value

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
