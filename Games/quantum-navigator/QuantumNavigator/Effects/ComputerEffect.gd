extends Node2D

onready var animatedSprite = $AnimatedSprite

signal computer_effect_done(position)
signal computer_effect_start

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("Animate")
	self.connect("computer_effect_done",
		$"/root/World/YSort/Otter",
		"_on_Computer_effect_process_done")
	$"/root/World/YSort/Otter".call("_on_Computer_effect_process_start")

func _on_AnimatedSprite_animation_finished():
	emit_signal("computer_effect_done", position)
