extends Node2D

onready var playerDetectionZone = $PlayerDetectionZone
onready var dialogPlayer = $Dialog_Player

func _physics_process(_delta):
	if playerDetectionZone.can_see_player():
		OtterStats.set_can_see_fire_hazard(true)
		if Input.is_action_just_pressed("info"):
			dialogPlayer.play_dialog("FireHazardInfoBox")
	else:
		OtterStats.set_can_see_fire_hazard(false)
		dialogPlayer.stop_dialog()

func create_fire_effect():
	var FireEffect = load("res://Effects/FireEffect.tscn")
	var fireEffect = FireEffect.instance()
	var world = get_tree().current_scene
	world.add_child(fireEffect)
	fireEffect.global_position = global_position

func _on_Hitbox_area_entered(_area):
	create_fire_effect()
