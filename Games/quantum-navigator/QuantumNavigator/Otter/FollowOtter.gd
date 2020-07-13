extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export(NodePath) var PARENT

enum {
	MOVE,
	PUSH,
	SHOOT
}

var state = MOVE
var velocity = Vector2.ZERO
var stats = OtterStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox

func _ready():
#	stats.connect("no_health", self, "queue_free")
	$End_Teleport_Particles.emitting = true

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
	var parent = get_node(PARENT)

	input_vector.x = parent.position.x - position.x
	input_vector.y = parent.position.y - position.y
	if (input_vector.length() < 30): input_vector = Vector2.ZERO

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
	
	if Input.is_action_just_pressed("push"):
		state = PUSH

	if Input.is_action_just_pressed("shoot"):
		state = SHOOT

func push_state():
	animationState.travel("Push")
	
func shoot_state():
	animationState.travel("Shoot")

func shoot_animation_finished():
	reset_to_move_state()

func push_animation_finished():
	reset_to_move_state()
	
func reset_to_move_state():
	velocity = Vector2.ZERO
	state = MOVE

func _on_Hurtbox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
