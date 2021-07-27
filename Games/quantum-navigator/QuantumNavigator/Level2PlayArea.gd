extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var see_player_debounce = false
var old_zoom
onready var camera = get_tree().get_current_scene().get_node("Camera2D")
var held_rm_trans

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if see_player_debounce == false:
			old_zoom = camera.zoom
			camera.zoom = camera.zoom * 2
			
			var rmTrans = OtterStats.curr_camera_rmtrans2d
			held_rm_trans = rmTrans
			var otter = OtterStats.curr_main_player
			print(otter.followers)
			rmTrans.position = $RemoteTransform2DRef.position
			otter.remove_child(rmTrans)
			self.add_child(rmTrans)
			
			see_player_debounce = true
			OtterStats.set_camera_locked(true)
		else:
			held_rm_trans.position = Vector2(OtterStats.curr_main_player.position.x - $RemoteTransform2DRef.global_position.x, $RemoteTransform2DRef.position.y)
	else:
		if (not playerDetectionZone.can_see_player()) and see_player_debounce == true:
			camera.zoom = old_zoom
			
			var rmTrans = $RemoteTransform2D
			self.remove_child(rmTrans)
			rmTrans.position = Vector2(0, 0)
			OtterStats.curr_main_player.add_child(rmTrans)
			OtterStats.set_camera_locked(false)
			see_player_debounce = false
			
