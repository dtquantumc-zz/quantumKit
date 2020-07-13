extends KinematicBody2D

func _on_Hurtbox_area_entered(area):
	OtterStats.pickles += 1
	queue_free()
