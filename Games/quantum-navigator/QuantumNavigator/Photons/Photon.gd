extends Node2D

# onready var targetAnimation = $TargetAnimation
onready var photonAnimation = $Photon/PhotonAnimation
onready var waveAnimation = $Photon/WaveAnimation
onready var hitbox = $Photon/Hitbox/CollisionShape2D
onready var particles = $Particles2D

onready var x
onready var y 

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.position = get_viewport().get_canvas_transform().affine_inverse().xform(get_viewport_rect().position)
	self.position.x += stepify(rng.randi_range(0,200),50)
	self.position.y -= 25
	waveAnimation.play("blueWave")
	x = self.position.x+1000
	y = self.position.y+1000
	
func _process(delta):
	self.position = position.move_toward(Vector2(x,y), delta * 150)
	if self.position.x == x:
		get_parent().remove_child(self)


func _on_Hitbox_body_entered(body):
	body.decohere()
