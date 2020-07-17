extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

enum {
	MOVE,
	STOP
}

var rng = RandomNumberGenerator.new()

var state = STOP
var velocity = Vector2.ZERO
var dir = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox

func _ready():
#	stats.connect("no_health", self, "queue_free")
	$End_Teleport_Particles.emitting = true

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
	hurtbox.start_invincibility(0.5)
