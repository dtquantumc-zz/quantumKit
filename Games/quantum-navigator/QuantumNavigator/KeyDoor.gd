extends StaticBody2D

# Script attached to a door requiring keys

# export allows the value to be modified in inspector with type specified
export(int) var NumKeysRequired = 1

var opened : bool = false

# Runs upon an object entering the area
# If the required amount of keys is reached and the door is not
# opened, the door becomes open
func _on_Area2D_area_entered(_area):
	if OtterStats.keys >= NumKeysRequired and !opened:
		opened = true
		OtterStats.set_keys(OtterStats.keys - NumKeysRequired)
		$Collision.set_deferred("disabled", true)
		$Door.unlock_door()
