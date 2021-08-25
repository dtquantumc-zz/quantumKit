extends StaticBody2D

# Script attached to a LightWithObstacle that simplifies blowing up multiple
# boulder objects

signal should_explode()

# Emits the signal should_explode
func on_explode():
	emit_signal("should_explode")
