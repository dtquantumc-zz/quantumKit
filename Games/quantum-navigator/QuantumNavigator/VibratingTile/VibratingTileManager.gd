extends Node

# Script that vibrates/stops vibrating files

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var VibratingTileTimer = $VibratingTileTimer
# Number of tiles set vibrating upon each timer timeout
export(int) var maxActiveTiles : int = 10
# Time between vibrations
export(int) var timeBetweenVibrations : int = 5

var seenTiles : Array = []

# Called when the node enters the scene tree for the first time
# Starts the vibration timer
func _ready():
	VibratingTileTimer.wait_time = timeBetweenVibrations
	VibratingTileTimer.start()

# Adds tile to a list of potential tiles to vibrate
func add_tile(tile):
	seenTiles.append(tile)

# Removes tile from a list of potential tiles to vibrate
func remove_tile(tile):
	seenTiles.erase(tile)

# On timer timeout, randomly select tiles to vibrate
func _on_timer_finished():
	seenTiles.shuffle()
	for i in range(min(seenTiles.size(),maxActiveTiles)):
		seenTiles[i].start_vibrating()
