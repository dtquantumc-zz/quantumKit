extends KinematicBody2D

func _on_Hurtbox_area_entered(_area):
	OtterStats.blue_bits += 1
	queue_free()
