extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var opened = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if OtterStats.keys >= 4 and opened == false:
		opened = true
		OtterStats.set_keys(OtterStats.keys - 1)
		$Collision.set_deferred("disabled", true)
