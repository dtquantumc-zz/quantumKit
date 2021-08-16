extends Node2D

export var reg_speed = 2
export var run_speed = 70

onready var anim = $AnimationPlayer

var target = null
var wanderTarget = null
var chasing = false

func _process(delta):
	if target != null:
		$Sprite.set_flip_h(global_transform.origin.x > target.position.x)
		if (!chasing):
			anim.play("Jump")
			yield (anim, "animation_finished")
			chasing = true
		else:
			position = position.move_toward(target.position, delta*run_speed)
	else:
		chasing = false
		if wanderTarget == null:
			wanderTarget = Vector2(position.x + rand_range(-20, 30), position.y + rand_range(-20, 30))
		else:
			position = position.move_toward(wanderTarget, delta*reg_speed)
			$Sprite.set_flip_h(global_transform.origin.x > wanderTarget.x)
			if position == wanderTarget:
				wanderTarget = null
			
		
	

func _ready():
	pass
	



func _on_DetectBox_body_entered(body):
	target = body


func _on_DetectBox_body_exited(body):
	target = null
