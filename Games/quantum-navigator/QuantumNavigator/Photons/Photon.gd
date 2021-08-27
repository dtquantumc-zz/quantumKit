extends Node2D

# Script attached to a photon in Level 3

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
# onready var targetAnimation = $TargetAnimation
onready var photonAnimation = $Photon/PhotonAnimation
onready var waveAnimation = $Photon/WaveAnimation
onready var hitbox = $Photon/Hitbox/CollisionShape2D
onready var particles = $Particles2D

onready var x
onready var y 

# Called when the node enters the scene tree for the first time.
# Sets the photon's initial position based on camera viewport
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.position = get_viewport().get_canvas_transform().affine_inverse().xform(get_viewport_rect().position)
	self.position.x += stepify(rng.randi_range(0,200),50)
	self.position.y -= 25
	waveAnimation.play("blueWave")
	x = self.position.x+1000
	y = self.position.y+1000
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Updates the position of this photon 
func _process(delta):
	self.position = position.move_toward(Vector2(x,y), delta * 150)

# Runs upon an object entering this hitbox (presumed to be an otter)
# Decoheres the otter it contacts
func _on_Hitbox_body_entered(body):
	body.decohere()
