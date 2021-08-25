extends Node2D

# Script attached to the area in Level 2 where the camera is zoomed out

onready var playerDetectionZone = $PlayerDetectionZone
onready var see_player_debounce = false
var old_zoom
onready var camera = get_tree().get_current_scene().get_node("Camera2D")
var held_rm_trans

# Called upon physics update (_delta = time between physics updates)
# Adjusts camera position and zoom if the player detection zone can see the
# player
func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		if !see_player_debounce:
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
		if !playerDetectionZone.can_see_player() and see_player_debounce:
			camera.zoom = old_zoom
			
			var rmTrans = $RemoteTransform2D
			self.remove_child(rmTrans)
			rmTrans.position = Vector2(0, 0)
			OtterStats.curr_main_player.add_child(rmTrans)
			OtterStats.set_camera_locked(false)
			see_player_debounce = false
			
