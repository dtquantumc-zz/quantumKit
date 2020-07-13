extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

enum {
	MOVE,
	PUSH,
	SHOOT
}

var state = MOVE
var entanglement_bit_direction = Vector2(0, 1)
var velocity = Vector2.ZERO
var stats = OtterStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox

# Timer for the entanglement bit projectile
onready var timer = get_node("Timer")

const ENTANGLEMENT_BIT_SCENE = preload("res://Projectiles/EntanglementBit.tscn")
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
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength("ui_right") -
		Input.get_action_strength("ui_left"))
	input_vector.y = (Input.get_action_strength("ui_down") -
		Input.get_action_strength("ui_up"))
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
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("push"):
		state = PUSH

	if Input.is_action_just_pressed("shoot"):
		state = SHOOT

func push_state():
	animationState.travel("Push")

func shoot_state():
	animationState.travel("Shoot")
	if timer.is_stopped() and UTIL.hasBitsToUse():
		if UTIL.hasRedBits():
			create_entanglement_bit(UTIL.RED)
		else:
			create_entanglement_bit(UTIL.BLUE)
		restart_timer()

func shoot_animation_finished():
	reset_to_move_state()

func push_animation_finished():
	reset_to_move_state()

func reset_to_move_state():
	velocity = Vector2.ZERO
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)

func create_entanglement_bit(color):
	var entanglementBit = ENTANGLEMENT_BIT_SCENE.instance()
	get_parent().add_child(entanglementBit)
	entanglementBit.start(entanglement_bit_direction, color)
	entanglementBit.set_global_position(get_node("Position2D").get_global_position())

func restart_timer():
	timer.start(0.5)

func _on_Timer_timeout():
	timer.stop()
