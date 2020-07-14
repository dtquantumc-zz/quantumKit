extends KinematicBody2D

func _on_Hurtbox_area_entered(_area):
	OtterStats.red_bits += 1
	queue_free()