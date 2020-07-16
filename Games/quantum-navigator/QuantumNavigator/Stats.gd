extends Node

export var max_health = 1
export var red_bits = 0 setget set_red_bits
export var blue_bits = 0 setget set_blue_bits
export var max_pickles = 2
export var pickles = 0 setget set_pickles
export var isEncoded = false

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal pickles_changed(value)
signal red_bits_changed(value)
signal blue_bits_changed(value)
signal max_pickles_collected

func set_health(value):
	health = value
	print(health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_pickles(value):
	pickles = value
	emit_signal("pickles_changed", pickles)
	if pickles == max_pickles:
		emit_signal("max_pickles_collected")

func set_red_bits(value):
	red_bits = value
	emit_signal("red_bits_changed", red_bits)

func set_blue_bits(value):
	blue_bits = value
	emit_signal("blue_bits_changed", blue_bits)

func reset():
	pickles = 0
	health = max_health
	red_bits = 0
	blue_bits = 0
	isEncoded = false
