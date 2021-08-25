# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node2D

# Script attached to the fire trap
# Currently unused.

const FireEffectResource = preload("res://Effects/FireEffect.tscn")
const OtterHurtSound = preload("res://Otter/OtterHurtSound.tscn")
var trap_idle = preload("res://Traps/trap.png")
var pickle = preload("res://Traps/firetraptest.png")

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
#onready var playerDetectionZone = $PlayerDetectionZone
#onready var dialogPlayer = $Dialog_Player
onready var trap_sprite = $SpikeTrapOpen
var debounce = false
var players = []

# Creates the fire effect in the scene and sets its position
func create_fire_effect():
	var fireEffect = FireEffectResource.instance()
	var world = get_tree().current_scene
	world.add_child(fireEffect)
	trap_sprite.set_texture(trap_idle)
	fireEffect.global_position = global_position

# Runs upon an object entering the 'hitbox'
# Note: hurtbox is not to be confused with the player detection zone
# Creates the fire effect upon object entering the hitbox
func _on_Hitbox_area_entered(_area):
	if debounce == false:
		debounce = true
		trap_sprite.set_texture(pickle)
		yield(get_tree().create_timer(1.0), "timeout")
		for player in players:
			print("found")
			OtterStats.health -= 1
			var otterHurtSound = OtterHurtSound.instance()
			get_tree().current_scene.add_child(otterHurtSound)
		debounce = false
		create_fire_effect()


func _on_Hitbox_body_entered(body):
	print('body')
	players.append(body)


func _on_Hitbox_body_exited(_body):
	players.erase(_body)


func _on_VibratingBlock_ready():
	trap_sprite.set_texture(trap_idle)
	
	while true:
		yield(get_tree().create_timer(rand_range(0, 3)), "timeout")
		if debounce == false:
			debounce = true
			trap_sprite.set_texture(pickle)
			yield(get_tree().create_timer(1.0), "timeout")
			for player in players:
				print("found")
				OtterStats.health -= 1
				var otterHurtSound = OtterHurtSound.instance()
				get_tree().current_scene.add_child(otterHurtSound)
			debounce = false
			create_fire_effect()

