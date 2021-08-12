# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends KinematicBody2D

# Script that controls Follower Otters and the Otter player character

const OtterHurtSound = preload("res://Otter/OtterHurtSound.tscn")
const ENTANGLEMENT_BIT_SCENE = preload("res://Projectiles/EntanglementBitProjectile.tscn")
const UTIL = preload("res://Utility.gd")
const VibratingTileHitbox = preload("res://VibratingTile/VibratingTileHitbox.gd")

# export allows the value to be modified in inspector with type specified
export var ACCELERATION = 500
export var REGULAR_SPEED = 80
export var SPRINT_SPEED = 110
export var FRICTION = 500
export(NodePath) var FOLLOW_TARGET = null
export(bool) var Debug = true
export var IS_MAIN = true

# Enum defining various Otter states

enum {
	MOVE,
	PUSH,
	SHOOT
}

var state = MOVE
var entanglement_bit_direction = Vector2(0, 1)
var velocity = Vector2.ZERO
var stats = OtterStats
var followers = []
var isTeleporting = false
var speed = REGULAR_SPEED

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var sprintParticles = $Sprint_Particles
onready var decFadeAnimationPlayer = $Decoherence/FadePlayer
onready var decFlashAnimationPlayer = $Decoherence/FlashPlayer
onready var measurementEffect = $MeasurementEffect

# Timer for the entanglement bit projectile
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
# Add a listener on no_health signal to call zero_health
func _ready():
	stats.connect("no_health", self, "zero_health")
	if $RemoteTransform2D != null:
		stats.set_curr_camera_rmtrans2d($RemoteTransform2D)
		stats.set_curr_main_player(self)
	print(stats.curr_main_player)
	print(stats.curr_camera_rmtrans2d)

func update_sprint():
	sprintParticles.rotation = entanglement_bit_direction.angle() + deg2rad(90)
	if Input.is_action_pressed("sprint") && velocity != Vector2.ZERO:
		sprintParticles.emitting = true
		speed = SPRINT_SPEED
		animationTree.set("parameters/BlendTree/TimeScale/scale", 2.0)
	else:
		sprintParticles.emitting = false
		speed = REGULAR_SPEED
		animationTree.set("parameters/BlendTree/TimeScale/scale", 1.0)


# Called upon physics update (_delta = time between physics updates)
# Perform an action every physics update (e.g. move, push, shoot)
func _physics_process(delta):
	update_sprint()
	match state:
		MOVE:
			move_state(delta)
		PUSH:
			push_state()
		SHOOT:
			shoot_state()

# Move the otter if not teleporting, and update animation/otter state based on
# key inputs.
# delta = delta time
func move_state(delta):
	if isTeleporting: return
	var input_vector = Vector2.ZERO

	if IS_MAIN == true:
		input_vector.x = (Input.get_action_strength("ui_right") -
			Input.get_action_strength("ui_left"))
		input_vector.y = (Input.get_action_strength("ui_down") -
			Input.get_action_strength("ui_up"))
	#else:

		#var target = get_node(FOLLOW_TARGET)
		#input_vector.x = target.position.x - position.x
		#input_vector.y = target.position.y - position.y
		#if (input_vector.length() < 30): input_vector = Vector2.ZERO

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		animationTree.set("parameters/Push/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)

		entanglement_bit_direction = input_vector
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	if velocity == Vector2.ZERO:
		animationState.travel("Idle")

	if Input.is_action_just_pressed("push"):
		#self.measure()
		if (!InfoDialogOpenState.get_is_info_dialog_open()):
			state = PUSH

	if Input.is_action_just_pressed("shoot"):
		state = SHOOT

	if Input.is_action_just_pressed("swap") and IS_MAIN == true:
		self.call_deferred("swap_followers")

# If the information dialogue is not open, set animation state to 'push'
func push_state():
	if (!InfoDialogOpenState.get_is_info_dialog_open()):
		animationState.travel("Push")

# Set the animation state to shoot and potentially create an entanglement bit
func shoot_state():
	animationState.travel("Shoot")
	if timer.is_stopped() and UTIL.hasBitsToUse():
		if UTIL.hasRedBits():
			TeleporterState.current_bit_color = UTIL.RED
			create_entanglement_bit()
		elif UTIL.hasBlueBits():
			TeleporterState.current_bit_color = UTIL.BLUE
			create_entanglement_bit()
		else:
			TeleporterState.current_bit_color = null
		restart_timer()

# upon shoot animation finish, move back to move state
func shoot_animation_finished():
	reset_to_move_state()

# upon push animation finish, move back to move state
func push_animation_finished():
	reset_to_move_state()

# Set state to move state and set velocity to 0
func reset_to_move_state():
	velocity = Vector2.ZERO
	state = MOVE

# On beginning of computer effect, show particles and set isTeleporting to true,
# so the player doesn't move while teleporting
func _on_Computer_effect_process_start():
	$Teleport_Particles.emitting = true
	isTeleporting = true

# Upon computer effect finish, create 2 new followers
func _on_Computer_effect_process_done(computer_position):
	$Teleport_Particles.emitting = false
	$End_Teleport_Particles.emitting = true
#	self.position = 2 * computer_position - self.position
	self.spawn_followers(2)
	var comput_dir = (computer_position - self.position).normalized()
	var perp = Vector2(-comput_dir.y, comput_dir.x)
	var center_pos = computer_position + 10 * comput_dir
	
	if OtterStats.curr_level == 2:
		self.position = get_tree().get_nodes_in_group("level2_otter_start_positions")[2].position
		followers[0].position = get_tree().get_nodes_in_group("level2_otter_start_positions")[0].position
		followers[1].position = get_tree().get_nodes_in_group("level2_otter_start_positions")[1].position
		
		var backdoors = get_tree().get_nodes_in_group("level2_backdoors")
		for door in backdoors:
			door.make_closed()
	else:
		self.position = center_pos + 5 * perp
		followers[0].position = center_pos
		followers[1].position = center_pos - 15 * perp
	
	stats.isEncoded = true
	isTeleporting = false

# Create num_followers followers that are following this otter
func spawn_followers(num_followers):
	for _i in range(num_followers):
		var newFollower = load("res://Otter/Otter.tscn").instance()
		get_parent().add_child(newFollower)
		followers.append(newFollower)

	followers[0].position = position + Vector2(-20, 0)
	#followers[0].FOLLOW_TARGET = self.get_path()
	followers[0].IS_MAIN = false
	followers[0].get_node("End_Teleport_Particles").emitting = true
	for i in range(1, followers.size()):
		followers[i].position = followers[i-1].position + Vector2(-20, 0)
		#followers[i].FOLLOW_TARGET = self.get_path()
		followers[i].IS_MAIN = false
		followers[i].get_node("End_Teleport_Particles").emitting = true

# Swap followers and set a new follower as the follow target
func swap_followers():
	print(followers.size())
	if (followers.size() == 0):
		return
	var mainOtter = followers[0]
	for i in range(1, followers.size()):
		mainOtter.followers.append(followers[i])
	mainOtter.FOLLOW_TARGET = null
	mainOtter.IS_MAIN = true
	IS_MAIN = false
	stats.set_curr_main_player(mainOtter)
	FOLLOW_TARGET = followers[-1].get_path()
	mainOtter.followers.append(self)
	followers = []
	if not OtterStats.camera_locked:
		var rmTrans = $RemoteTransform2D
		self.remove_child(rmTrans)
		mainOtter.add_child(rmTrans)

# Runs upon an object entering the 'hurtbox'
# Upon object entering the hurtbox, check if current otter is a follower
# before decreasing health/blinking due to being in a trap
func _on_Hurtbox_area_entered(area):
	if is_a_follower_otter():
		print("I am a follower")
		return
	# if is_a_fire_trap(area):
	# 	blinkAnimationPlayer.play("Start")
	# elif is_a_vibrating_block(area):
	# 	print("kk")
	# else:
	# 	stats.health -= 1
	# 	var otterHurtSound = OtterHurtSound.instance()
	# 	get_tree().current_scene.add_child(otterHurtSound)
	if !(area is VibratingTileHitbox):
		if !is_a_fire_trap(area):
			take_damage()
		else:
			blinkAnimationPlayer.play("Start")
	# hurtbox.start_invincibility(0.5)

# determines if a given area is a fire trap
func is_a_fire_trap(area) -> bool:
	if (Debug):
		print("is_a_fire_trap area name: " + area.get_name())
	if (area.owner == null):
		if (Debug):
			print("is_a_fire_trap area owner name: null")
		return false
	if (Debug):
		print("is_a_fire_trap area owner name: " + area.owner.get_name())
	return area.owner.get_name() in ["FireTrap", "SpikeTrap"]

func is_a_vibrating_block(area) -> bool:
		return area.owner.get_node("..").get_name() in ["VibratingBlocks"]
# decrements health and plays a hurt sound
func take_damage():
	stats.health -= 1
	var otterHurtSound = OtterHurtSound.instance()
	get_tree().current_scene.add_child(otterHurtSound)

# determines if this current otter object is a follower
func is_a_follower_otter():
	return IS_MAIN == false

# Runs upon an object exiting the 'hurtbox'
# If the area previously entered was a fire trap, stop blinking
# and play the otter hurt sound
func _on_Hurtbox_area_exited(area):
	if is_a_fire_trap(area):
		take_damage()
		blinkAnimationPlayer.play("Stop")

# Creates an entanglement bit in the direction the player is facing
func create_entanglement_bit():
	var entanglementBit = ENTANGLEMENT_BIT_SCENE.instance()
	get_parent().add_child(entanglementBit)
	entanglementBit.start(entanglement_bit_direction)
	entanglementBit.set_global_position(get_node("Position2D").get_global_position())

# Restarts an internal timer/cooldown for the entanglement bit
func restart_timer():
	timer.start(1)

# Stops the timer/cooldown for the entanglement bit upon timer reaching 0
func _on_Timer_timeout():
	timer.stop()

# Upon decoder process start, emit particles and set isTeleporting to true
# see also: _on_Computer_effect_process_start
func _on_Decoder_effect_process_start():
	$Teleport_Particles.emitting = true
	isTeleporting = true
	for i in range(1, followers.size()):
		followers[i].position = self.position + Vector2(-20, 0)
		followers[i].get_node("Teleport_Particles").emitting = true
	#for follower in followers:
	#	follower.get_node("Teleport_Particles").emitting = true

# Upon decoder process end, stop emitting particles, and delete all followers
# see also: _on_Computer_effect_process_end
func _on_Decoder_effect_process_done(computer_position):
	$Teleport_Particles.emitting = false
	$End_Teleport_Particles.emitting = true
#	self.position = 2 * computer_position - self.position
	for follower in followers:
		follower.queue_free()
	followers.clear()
	var comput_dir = (computer_position - self.position).normalized()

	var center_pos = computer_position + 10 * comput_dir
	self.position = center_pos

	stats.isEncoded = false
	isTeleporting = false

# Method called upon reaching 0 health (kill the otter)
func zero_health():
	if IS_MAIN == true:
		self.call_deferred("die")

# Method called upon the otter dying
# Either swap to follower or restart level depending on number of followers
func die():
	if followers.size() > 0:
		var mainOtter = followers[0]
		stats.set_curr_main_player(mainOtter)
		for i in range(1, followers.size()):
			mainOtter.followers.append(followers[i])
		mainOtter.FOLLOW_TARGET = null
		mainOtter.IS_MAIN = true
		IS_MAIN = false
		if not OtterStats.camera_locked:
			var rmTrans = $RemoteTransform2D
			print(rmTrans)
			self.remove_child(rmTrans)
			mainOtter.add_child(rmTrans)
		stats.health = stats.max_health
		queue_free()
	else:
		stats.health = stats.max_health
		get_parent().owner.queue_restart()
		queue_free()
		
func decohere():
	decFadeAnimationPlayer.play("Fade")
	decFlashAnimationPlayer.play("Flash")
	$Decoherence/Particles2D.emitting = true
	REGULAR_SPEED = 0
	SPRINT_SPEED = 0
	yield(get_tree().create_timer(3.0), "timeout")
	die()


func measure():
	measurementEffect.visible = true
	measurementEffect.frame = 0
	measurementEffect.play('default')
	
#func _on_Hurtbox_invincibility_started():
#	if FOLLOW_TARGET == null:
#		blinkAnimationPlayer.play("Start")
#
#func _on_Hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")


func _on_MeasurementEffect_animation_finished():
	measurementEffect.visible = false
	print("do the measurement")
