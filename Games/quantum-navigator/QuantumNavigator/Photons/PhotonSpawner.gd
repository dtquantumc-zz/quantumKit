extends Node2D

# Script attached to the photon spawned in level 3

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var area = $Area2D/CollisionShape2D
onready var size = area.shape.extents
onready var photon : PackedScene = load("res://Photons/Photon.tscn")
onready var playerInArea : bool = false

export(float) var HowOftenToSpawn : float = 1
export(float) var HowManyToSpawn : int = 1

# Called when the node enters the scene tree for the first time.
# Creates a timer that will call repeat_me every HowOftenToSpawn seconds
func _ready():
	var timer = Timer.new()
	timer.set_wait_time(HowOftenToSpawn)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "repeat_me")
	add_child(timer)
	timer.start()

# Called by the timer upon time running out
# If player is inside the area to spawn photons in, spawn HowManyToSpawn photons
func repeat_me():
	if playerInArea:
		for x in HowManyToSpawn:
			spawn()

# Creates a photon and adds it to the scene
func spawn():
	var spawn = photon.instance()
	add_child(spawn)

# Runs on an object (presumably an otter) entering the photon spawner area
# Internally sets that the player is in the area
func _on_Area2D_body_entered(_body):
	playerInArea = true

# Runs on an object (presumably an otter) exiting the photon spawner area
# Internally sets that the player is not in the area
func _on_Area2D_body_exited(_body):
	playerInArea = false
