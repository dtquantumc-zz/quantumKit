extends StaticBody2D

onready var Boulders = $Boulders

signal should_explode()

func on_explode():
	emit_signal("should_explode")
