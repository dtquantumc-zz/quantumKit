extends Node2D


onready var area = $Area2D/CollisionShape2D
onready var size = area.shape.extents
onready var photon = load("res://Photons/Photon.tscn")
onready var playerInArea = false

export(float) var HowOftenToSpawn : float = 1
export(float) var HowManyToSpawn : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.set_wait_time(HowOftenToSpawn)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "repeat_me")
	add_child(timer)
	timer.start()

func repeat_me():
	if playerInArea:
		for x in HowManyToSpawn:
			spawn()
	
func spawn():
	var spawn = photon.instance()
	add_child(spawn)

func _on_Area2D_body_entered(body):
	playerInArea = true


func _on_Area2D_body_exited(body):
	playerInArea = false
