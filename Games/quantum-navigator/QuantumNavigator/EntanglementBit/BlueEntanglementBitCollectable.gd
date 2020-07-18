extends KinematicBody2D

const PickupItemEffect = preload("res://Effects/PickUpItemEffect.tscn")
const BitCollectionSound = preload("res://EntanglementBit/BitCollectionSound.tscn")

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

var bit_collected = false

func _physics_process(_delta):
	# TODO: Temporary so the 2nd entanglement bit on top of the fire trap
	# doesn't create a help icon that overlaps with the help icon of the
	# fire trap itself in Level2_Maze
	var is_second_bit = get_name() == "BlueEntanglementBitCollectable2"

	if !is_second_bit and !bit_collected and playerDetectionZone.can_see_player():
		OtterStats.set_can_see_blue_bell_pair({"name": get_name(), "value": true})
		if Input.is_action_just_pressed("info") || !InfoDialogState.get_has_bell_pair_dialog_been_seen():
			dialogPlayer.play_dialog("BellPairsInfoBox")

		if !InfoDialogState.get_has_bell_pair_dialog_been_seen():
			InfoDialogState.set_has_bell_pair_dialog_been_seen(true)
	else:
		OtterStats.set_can_see_blue_bell_pair({"name": get_name(), "value": false})
		dialogPlayer.stop_dialog()

func create_pickupitem_effect():
	var pickupItemEffect = PickupItemEffect.instance()
	get_parent().add_child(pickupItemEffect)
	pickupItemEffect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	OtterStats.blue_bits += 1
	create_pickupitem_effect()

	OtterStats.set_can_see_blue_bell_pair({"name": get_name(), "value": false})
	dialogPlayer.stop_dialog()
	bit_collected = true

	var bitCollectionSound = BitCollectionSound.instance()
	get_parent().add_child(bitCollectionSound)

	queue_free()
