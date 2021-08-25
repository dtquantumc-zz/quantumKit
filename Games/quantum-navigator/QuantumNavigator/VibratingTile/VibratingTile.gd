extends Node

# Script attached to a vibrating tile

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var playerDetectionZone = $PlayerDetectionZone
onready var vibrationPlayer = $VibrationPlayer
onready var dialogPlayer = $Dialog_Player
onready var vibratingTileHitbox = $Hitbox
onready var timer = $Timer
onready var particles = $Particles2D

# List of slow vibrations
export(Array, String) var SlowAnimations : Array = ["VibrateSlow","VibrateSlow2"]
# List of Fast Vibrations
export(Array, String) var FastAnimations : Array = ["VibrateFast"]
# Particles when slow vibrating
export(float) var ParticleSlowVibrating : float = 8
# Particle speed when slow vibrating
export(float) var ParticleSlowSpeed : float = 12
# Particles when fast vibrating
export(float) var ParticleFastVibrating : float = 16
# Particle speed when fast vibrating
export(float) var ParticleFastSpeed : float = 25
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

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time
# Initializes the RNG
func _ready():
	rng.randomize()

# Internally sets the otter, and if the otter is on this object while vibrating,
# make it take damage
func _set_otter(otter):
	otterInside = otter
	if state == 2:
		if (Debug):
			print("Vibrating Tile _set_otter Otter name: " + otterInside.get_name())
		otterInside.take_damage()

# Utility to play an animation in reverse randomly
func _play_random_reverse(var animName : String) -> void:
	var reverse : bool = _random_reverse()
	if (reverse):
		vibrationPlayer.play_backwards(animName)
	else:
		vibrationPlayer.play(animName)

# Utility to return a random boolean
func _random_reverse() -> bool:
	var result : int = rng.randi_range(0,1)
	return result == 1

# Begin the timer for vibrating, if it can
func start_vibrating():
	if ForceNeverVibrate:
		return
	if state == 0:
		state = 1
		timer.wait_time = TimeSlowVibrate
		var index : int = rng.randi_range(0,SlowAnimations.size()-1)
		_play_random_reverse(SlowAnimations[index])
		particles.emitting = true
		particles.amount = ParticleSlowVibrating
		particles.process_material.initial_velocity = ParticleSlowSpeed
		if (Debug):
			print("[VibratingTile.gd start_vibrating]: Vibrating soon...")
		timer.start()

# Runs on timer timeout
# Updates internal state after specified time intervals
func _on_timer_timeout():
	if state == 1:
		timer.wait_time = TimeFullVibrate
		if (Debug):
			print("[VibratingTile.gd start_vibrating]: Vibrating")
		var index : int = rng.randi_range(0,FastAnimations.size()-1)
		_play_random_reverse(FastAnimations[index])
		particles.amount = ParticleFastVibrating
		particles.process_material.initial_velocity = ParticleFastSpeed
		timer.start()
		if otterInside != null:
			otterInside.take_damage()	
		state = 2
	elif state == 2:
		vibrationPlayer.play("IdleAnim")
		particles.emitting = false
		timer.wait_time = MinTimeBeforeVibrate
		timer.start()
		if (Debug):
			print("[VibratingTile.gd start_vibrating]: No longer vibrating")
		state = 3
	elif state == 3:
		if (Debug):
			print("[VibratingTile.gd start_vibrating]: Vibrating Cooldown over")
		state = 0

# When player is close to the vibrating tile, signal to the tile manager
# that this tile can vibrate
func _on_player_close(_body):
	self.get_parent().add_tile(self)

# When player is far from the vibrating tile, signal to the tile manager
# that this tile should not vibrate
func _on_player_not_close(_body):
	self.get_parent().remove_tile(self)

# Runs upon an object entering the 'hitbox'
# Internally sets the otter that entered this area
# Note: hurtbox is not to be confused with the player detection zone
func _on_Hitbox_area_entered(_area):
	if (Debug):
		print("[VibratingTile.gd start_vibrating]: Otter entered vibrating tile: " + _area.get_name())
	_set_otter(_area.get_parent())
	
# Runs upon an object exiting the 'hitbox'
# Internally removes the otter that entered this area
# Note: hurtbox is not to be confused with the player detection zone
func _on_Hitbox_area_exited(_area):
	otterInside = null
