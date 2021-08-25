extends StaticBody2D

# Script attached to a given measurement area

# Runs upon object entering the measurement area
# Signals to OtterStats that the current measurement area is this current area
func _on_Hurtbox_area_entered(area):
	OtterStats.set_measurement_area(self.get_parent().name)

# Runs upon object exiting the measurement area
# Signals to OtterStats that this measurement area is no longer active
func _on_Hurtbox_area_exited(area):
	OtterStats.set_measurement_area(0)
