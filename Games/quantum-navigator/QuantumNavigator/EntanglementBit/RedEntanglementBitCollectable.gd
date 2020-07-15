extends KinematicBody2D

const PickupItemEffect = preload("res://Effects/PickUpItemEffect.tscn")

func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
    pickupItemEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
    OtterStats.red_bits += 1
    create_pickupitem_effect()
	queue_free()