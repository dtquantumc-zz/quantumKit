extends Node

export var max_health = 1
export var red_bits = 2 setget set_red_bits
export var blue_bits = 2 setget set_blue_bits
export var max_pickles = 2
export var pickles = 0 setget set_pickles
export var isEncoded = false

export var can_see_encoder = false setget set_can_see_encoder
export var can_see_decoder = false setget set_can_see_decoder
export var can_see_teleporter = false setget set_can_see_teleporter
export var can_see_fire_hazard = false setget set_can_see_fire_hazard

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal pickles_changed(value)
signal red_bits_changed(value)
signal blue_bits_changed(value)
signal max_pickles_collected

signal encoder_visible(value)
signal decoder_visible(value)
signal teleporter_visible(value)
signal fire_hazard_visible(value)

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

func set_can_see_encoder(value):
	can_see_encoder = value
	emit_signal("encoder_visible", can_see_encoder)

func set_can_see_decoder(value):
	can_see_decoder = value
	emit_signal("decoder_visible", can_see_decoder)

func set_can_see_teleporter(value):
	can_see_teleporter = value
	emit_signal("teleporter_visible", can_see_teleporter)

func set_can_see_fire_hazard(value):
	can_see_fire_hazard = value
	emit_signal("fire_hazard_visible", can_see_fire_hazard)