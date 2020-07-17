extends KinematicBody2D

const PickupItemEffect = preload("res://Effects/PickUpItemEffect.tscn")

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var bit_collected = false

func _physics_process(_delta):
	if !bit_collected and playerDetectionZone.can_see_player():
		OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": true})
		if Input.is_action_just_pressed("info"):
			dialogPlayer.play_dialog("BellPairsInfoBox")
	else:
		OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": false})
		dialogPlayer.stop_dialog()

func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
	pickupItemEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	OtterStats.red_bits += 1
	create_pickupitem_effect()

	OtterStats.set_can_see_red_bell_pair({"name": get_name(), "value": false})
	dialogPlayer.stop_dialog()
	bit_collected = true

	queue_free()
