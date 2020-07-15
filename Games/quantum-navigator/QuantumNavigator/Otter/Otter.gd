extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export(NodePath) var FOLLOW_TARGET = null

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

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox


# Timer for the entanglement bit projectile
onready var timer = get_node("Timer")

const ENTANGLEMENT_BIT_SCENE = preload("res://Projectiles/EntanglementBitProjectile.tscn")
const UTIL = preload("res://Utility.gd")

func _ready():
	stats.connect("no_health", self, "queue_free")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		PUSH:
			push_state()
		SHOOT:
			shoot_state()

func move_state(delta):
	if isTeleporting: return
	var input_vector = Vector2.ZERO
	
	if FOLLOW_TARGET == null:	
		input_vector.x = (Input.get_action_strength("ui_right") -
			Input.get_action_strength("ui_left"))
		input_vector.y = (Input.get_action_strength("ui_down") -
			Input.get_action_strength("ui_up"))
	else:
		var target = get_node(FOLLOW_TARGET)
		input_vector.x = target.position.x - position.x
		input_vector.y = target.position.y - position.y
		if (input_vector.length() < 30): input_vector = Vector2.ZERO
	
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		animationTree.set("parameters/Push/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

		entanglement_bit_direction = input_vector
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	if velocity == Vector2.ZERO:
		animationState.travel("Idle")

	if Input.is_action_just_pressed("push"):
		state = PUSH

	if Input.is_action_just_pressed("shoot"):
		state = SHOOT
	
	if Input.is_action_just_pressed("swap") and FOLLOW_TARGET == null:
		self.call_deferred("swap_followers")

func push_state():
	animationState.travel("Push")

func shoot_state():
	animationState.travel("Shoot")
	if timer.is_stopped() and UTIL.hasBitsToUse():
		if UTIL.hasRedBits():
			TeleporterState.current_bit_color = UTIL.RED
			create_entanglement_bit()
		else:
			TeleporterState.current_bit_color = UTIL.BLUE
			create_entanglement_bit()
		restart_timer()

func shoot_animation_finished():
	reset_to_move_state()

func push_animation_finished():
	reset_to_move_state()

func reset_to_move_state():
	velocity = Vector2.ZERO
	state = MOVE

func _on_Computer_effect_process_start():
	$Teleport_Particles.emitting = true
	isTeleporting = true

func _on_Computer_effect_process_done(computer_position):
	$Teleport_Particles.emitting = false
	$End_Teleport_Particles.emitting = true
#	self.position = 2 * computer_position - self.position
	self.spawn_followers(2)
	var comput_dir = (computer_position - self.position).normalized()
	var perp = Vector2(-comput_dir.y, comput_dir.x)
	var center_pos = computer_position + 30 * comput_dir
	self.position = center_pos + 15 * perp
	followers[0].position = center_pos
	followers[1].position = center_pos - 15 * perp
	stats.isEncoded = true
	isTeleporting = false

func spawn_followers(num_followers):
	for _i in range(num_followers):
		followers.append(load("res://Otter/Otter.tscn").instance())
		get_parent().add_child(followers[-1])

	followers[0].position = position + Vector2(-20, 0)
	followers[0].FOLLOW_TARGET = self.get_path()
	followers[0].get_node("End_Teleport_Particles").emitting = true
	for i in range(1, followers.size()):
		followers[i].position = followers[i-1].position + Vector2(-20, 0)
		followers[i].FOLLOW_TARGET = followers[i-1].get_path()
		followers[i].get_node("End_Teleport_Particles").emitting = true

func swap_followers():
	print(followers.size())
	if (followers.size() == 0):
		return
	var mainOtter = followers[0]
	for i in range(1, followers.size()):
		mainOtter.followers.append(followers[i])
	mainOtter.FOLLOW_TARGET = null
	FOLLOW_TARGET = followers[-1].get_path()
	mainOtter.followers.append(self)
	followers = []
	var rmTrans = $RemoteTransform2D
	self.remove_child(rmTrans)
	mainOtter.add_child(rmTrans)
	

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	# hurtbox.start_invincibility(0.5)

func create_entanglement_bit():
	var entanglementBit = ENTANGLEMENT_BIT_SCENE.instance()
	get_parent().add_child(entanglementBit)
	entanglementBit.start(entanglement_bit_direction)
	entanglementBit.set_global_position(get_node("Position2D").get_global_position())

func restart_timer():
	timer.start(1)

func _on_Timer_timeout():
	timer.stop()

func _on_Decoder_effect_process_start():
	$Teleport_Particles.emitting = true
	isTeleporting = true
	for follower in followers:
		follower.get_node("Teleport_Particles").emitting = true

func _on_Decoder_effect_process_done(computer_position):
	$Teleport_Particles.emitting = false
	$End_Teleport_Particles.emitting = true
#	self.position = 2 * computer_position - self.position
	for follower in followers:
		follower.queue_free()
	followers.clear()
	var comput_dir = (computer_position - self.position).normalized()

	var center_pos = computer_position + 30 * comput_dir
	self.position = center_pos

	stats.isEncoded = false
	isTeleporting = false
