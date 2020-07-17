extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func restart(time=0):
	if time > 0:
		yield(get_tree().create_timer(time), "timeout")
	OtterStats.reset()
	TeleporterState.reset()
	get_tree().reload_current_scene()

func queue_restart():
	self.call_deferred("restart", 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()

