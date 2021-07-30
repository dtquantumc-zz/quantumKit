extends Node

# Script attached to a vibrating tile

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var dialogPlayer = $Dialog_Player
onready var vibratingTileHitbox = $Hitbox
onready var timer = $Timer

# Time when slowly vibrating
export(float) var TimeSlowVibrate : float= 3
# Time of vibration (to kill)
export(float) var TimeFullVibrate : float = 2
# Time after full vibration before it can start vibrating
export(float) var MinTimeBeforeVibrate : float = 2
# Whether the tile should vibrate
export(bool) var ForceNeverVibrate : bool = false
# Whether debug statements are printed
export(bool) var Debug = false

var otterInside = null setget _set_otter
# 0 = not vibrating, 1 = vibrating slightly, 2 = kill, 3 = cooldown
var state : int = 0

# Internally sets the otter, and if the otter is on this object while vibrating,
# make it take damage
func _set_otter(otter):
	otterInside = otter
	if state == 2:
		if (Debug):
			print("Vibrating Tile _set_otter Otter name: " + otterInside.get_name())
		otterInside.take_damage()

# Begin the timer for vibrating, if it can
func start_vibrating():
	if ForceNeverVibrate:
		return
	if state == 0:
		state = 1
		timer.wait_time = TimeSlowVibrate
		animationPlayer.play("VibrateSlow")
		if (Debug):
			print("Vibrating soon...")
		timer.start()

# Runs on timer timeout
# Updates internal state after specified time intervals
func _on_timer_timeout():
	if state == 1:
		timer.wait_time = TimeFullVibrate
		if (Debug):
			print("Vibrating")
		animationPlayer.play("VibrateFast")
		timer.start()
		if otterInside != null:
			otterInside.take_damage()	
		state = 2
	elif state == 2:
		animationPlayer.play("IdleAnim")
		timer.wait_time = MinTimeBeforeVibrate
		timer.start()
		if (Debug):
			print("No longer vibrating")
		state = 3
	elif state == 3:
		if (Debug):
			print("Vibrating Cooldown over")
		state = 0

# When player is close to the vibrating tile, signal to the tile manager
# that this tile can vibrate
func _on_player_close(body):
	self.get_parent().add_tile(self)

# When player is far from the vibrating tile, signal to the tile manager
# that this tile should not vibrate
func _on_player_not_close(body):
	self.get_parent().remove_tile(self)

# Runs upon an object entering the 'hitbox'
# Internally sets the otter that entered this area
# Note: hurtbox is not to be confused with the player detection zone
func _on_Hitbox_area_entered(_area):
	if (Debug):
		print("Otter entered vibrating tile: " + _area.get_name())
	_set_otter(_area.get_parent())
	
# Runs upon an object exiting the 'hitbox'
# Internally removes the otter that entered this area
# Note: hurtbox is not to be confused with the player detection zone
func _on_Hitbox_area_exited(_area):
	otterInside = null
