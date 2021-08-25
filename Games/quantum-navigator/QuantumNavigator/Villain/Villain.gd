extends Node2D

# Script attached to the villain in level 4

# export allows the value to be modified in inspector with type specified
export(int) var reg_speed : int = 2
export(int) var run_speed : int = 70

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var anim = $AnimationPlayer
onready var animTree = $AnimationTree

var target = null
var wanderTarget = null
var chasing : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Adjusts target and moves towards the otter if target is visible
func _process(delta):
	if target != null:
		if (!chasing):
			animTree.set("parameters/blend_position", Vector2(0,1))
			anim.play("Jump")
			yield (anim, "animation_finished")
			chasing = true
		else:
			position = position.move_toward(target.position, delta*run_speed)
			animTree.set("parameters/blend_position", target.position - position)
	else:
		chasing = false
		if wanderTarget == null:
			wanderTarget = Vector2(position.x + rand_range(-20, 30), position.y + rand_range(-20, 30))
		else:
			position = position.move_toward(wanderTarget, delta*reg_speed)
			animTree.set("parameters/blend_position", wanderTarget - position)
			if position == wanderTarget:
				wanderTarget = null

# Runs upon object entering the detection area/detection box
# Internally sets the target to be the new object
func _on_DetectBox_body_entered(body):
	target = body

# Runs upon object exiting the detection area/detection box
# Internally removes the target
func _on_DetectBox_body_exited(_body):
	target = null
