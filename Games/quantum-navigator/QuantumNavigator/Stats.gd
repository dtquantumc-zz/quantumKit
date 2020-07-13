extends Node

export var max_health = 1
onready var health = max_health setget set_health
var pickles = 0 setget set_pickles

signal no_health
signal health_changed(value)
signal pickles_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_pickles(value):
	pickles = value
	emit_signal("pickles_changed", pickles)
