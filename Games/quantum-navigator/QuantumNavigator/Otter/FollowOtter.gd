# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends KinematicBody2D

# Script attached to FollowOtter object
# Note: Normal Otter objects are created instead... this does not appear to be
# used

# export allows the value to be modified in inspector with type specified
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

# Enum defining otter states (e.g. moving, not moving)
enum {
	MOVE,
	STOP
}

var rng = RandomNumberGenerator.new()

var state = STOP
var velocity = Vector2.ZERO
var dir = Vector2.ZERO

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
# Hides the teleportation particles
func _ready():
#	stats.connect("no_health", self, "queue_free")
	$End_Teleport_Particles.emitting = true

# Called upon physics update (_delta = time between physics updates)
# Moves the otter in apparently random directions
func _physics_process(delta):
	move_state(delta)
	match state:
		MOVE:
			if rng.randi_range(0, 60) < 1:
				state = STOP
				dir = Vector2.ZERO
		STOP:
			if rng.randi_range(0, 60) < 1:
				state = MOVE
				dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

# Changes velocity/animation state based on delta time
func move_state(delta):
	var input_vector = dir

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		animationTree.set("parameters/Push/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	if velocity == Vector2.ZERO:
		animationState.travel("Idle")

# Move to the 'push' animation state
func push_state():
	animationState.travel("Push")

# Move to the 'shoot' animation state
func shoot_state():
	animationState.travel("Shoot")

# Upon shoot animation finished, move back to 'move' state
func shoot_animation_finished():
	reset_to_move_state()

# Upon push animation finished, move back to 'move' state
func push_animation_finished():
	reset_to_move_state()

# Sets velocity to zero while being in 'move' state
func reset_to_move_state():
	velocity = Vector2.ZERO
	state = MOVE

# Runs upon an object entering the 'hurtbox'
# Note: hurtbox is not to be confused with the player detection zone
# Sets invincibility timer upon object entering hurtbox
func _on_Hurtbox_area_entered(_area):
	hurtbox.start_invincibility(0.5)
