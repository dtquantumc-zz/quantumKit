# MIT License

# Portions Copyright (c) 2020 David E Lipps
# Portions Copyright (c) 2020 Diversifying Talent in Quantum Computing, Geering Up, UBC

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

extends Node

onready var _Body_AnimationPlayer = self.find_node("Body_AnimationPlayer")
onready var _Body_LBL = self.find_node("Body_Label")
onready var _Dialog_Box = self.find_node("Dialog_Box")
onready var _Speaker_LBL = self.find_node("Speaker_Label")
onready var _SpaceBar_Icon = self.find_node("SpaceBar_NinePatchRect")
onready var _Anim = self.find_node("AnimationPlayer")
onready var _Dialog_Open = false

var _did = 0
var _nid = 0
var _final_nid = 0
var _Story_Reader
var _signal

# Virtual Methods

func _ready():
	var Story_Reader_Class = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	_Story_Reader = Story_Reader_Class.new()

	_Story_Reader.read(load(_get_story()))

	_Dialog_Box.visible = false
	_SpaceBar_Icon.visible = false

func _input(event):
	if event is InputEventKey:
		if event.pressed == true and (event.scancode == KEY_SPACE or event.scancode == KEY_Z):
			_on_Dialog_Player_pressed_spacebar()

# Callback Methods

func _on_Body_AnimationPlayer_animation_finished(anim_name):
	_SpaceBar_Icon.visible = true


func _on_Dialog_Player_pressed_spacebar():
	if _is_waiting():
		_SpaceBar_Icon.visible = false
		_get_next_node()
		if _is_playing():
			_play_node()

# Public Methods

func play_dialog(record_name : String):
	_set_open_state_signal(record_name)
	_did = _Story_Reader.get_did_via_record_name(record_name)
	_nid = self._Story_Reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = _Story_Reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	_Dialog_Open = true
	_Dialog_Box.visible = true
	_emit_dialog_open_signal(true)
	get_tree().paused = true
	_Anim.stop()
	_Anim.play("dialog_appear")

func stop_dialog():
	if _is_playing():
		_Dialog_Open = false
		_Dialog_Box.visible = false
		_emit_dialog_open_signal(false)


# Private Methods

func _set_open_state_signal(record_name : String):
	match record_name:
		"GameIntroInfoBox":
			_signal = "game_intro_dialog_open"
		"BellPairsInfoBox":
			_signal = "bell_pair_dialog_open"
		"TeleporterInfoBox":
			_signal = "teleporter_dialog_open"
		"EncoderInfoBox":
			_signal = "encoder_dialog_open"
		"DecoderInfoBox":
			_signal = "decoder_dialog_open"
		"FireHazardInfoBox":
			_signal = "fire_trap_dialog_open"

func _is_playing():
	return _Dialog_Open


func _is_waiting():
	return _SpaceBar_Icon.visible


func _get_next_node():
	_nid = _Story_Reader.get_nid_from_slot(_did, _nid, 0)

	if _nid == _final_nid:
		_Dialog_Open = false
		get_tree().paused = false;
		_Anim.stop()
		_Anim.play("dialog_disappear")
		yield(_Anim, "animation_finished")
		_Dialog_Box.visible = false
		_emit_dialog_open_signal(false)


func _get_tagged_text(tag : String, text : String):
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)


func _play_node():
	var text = _Story_Reader.get_text(_did, _nid)
	var speaker = _get_tagged_text("speaker", text)
	var dialog = _get_tagged_text("dialog", text)

	_Speaker_LBL.text = speaker
	_Body_LBL.text = dialog
	_Body_AnimationPlayer.play("TextDisplay")

func _emit_dialog_open_signal(value):
	if _signal != null:
		InfoDialogOpenState.emit_signal(_signal, value)

func _get_story():
	# Default Example Story:
	# "res://Dialog-System-Example/stories/Example_Story_Baked.tres"

	return "res://Stories/InfoBoxesBakedStory.tres"
