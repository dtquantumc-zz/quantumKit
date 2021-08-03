extends Node2D


onready var area = $Area2D/CollisionShape2D
onready var size = area.shape.extents
onready var photon = load("res://Photons/Photon.tscn")

export(float) var HowOftenToSpawn : float = 10
export(float) var HowManyToSpawn : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	repeat_me()
	var timer = Timer.new()
	timer.set_wait_time(HowOftenToSpawn)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "repeat_me")
	add_child(timer)
	timer.start()

func repeat_me():
	for x in HowManyToSpawn:
		spawn()
	
func spawn():
	var positionInArea = Vector2(0,0)
	positionInArea.x = (randi() % int(size.x)) - (size.x/2) + area.position.x
	positionInArea.y = (randi() % int(size.y)) - (size.y/2) + area.position.y
	
	var spawn = photon.instance()
	spawn.position = positionInArea
	add_child(spawn)
