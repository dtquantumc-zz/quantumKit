extends Node2D

onready var targetAnimation = $TargetAnimation
onready var photonAnimation = $PhotonAnimation
onready var waveAnimation = $Photon/WaveAnimation
onready var hitbox = $Hitbox/CollisionShape2D
onready var particles = $Particles2D

func _ready():
	hitbox.set_disabled(true)
	shoot_photon()


func shoot_photon():
	yield(get_tree().create_timer(3.0),"timeout")
	targetAnimation.play("photonTarget")
	waveAnimation.play("blueWave")
	yield(get_tree().create_timer(3.0),"timeout")
	photonAnimation.play("moveToTarget")
	yield(photonAnimation,"animation_finished")
	particles.emitting = true
	hitbox.set_disabled(false)
	targetAnimation.seek(0)
	targetAnimation.stop()
	photonAnimation.play("hideWave")
	yield(get_tree().create_timer(3.0),"timeout")
	hitbox.set_disabled(true)
	particles.emitting = false
	get_parent().remove_child(self)
