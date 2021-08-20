extends Node2D

onready var KeySprite = $Sprite
onready var Hitbox = $Hitbox

var probability : float = 0 setget set_probability
export(bool) var in_key_area : bool = false
export(float) var MinRenderOpacity : float = 0.1
var is_solid : bool = false
var has_measured : bool = false
var objects_in_hitbox : Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	set_probability(5)

func set_probability(value: float) -> void:
	value = clamp(value,0,1)
	probability=value
	KeySprite.modulate.a = max(MinRenderOpacity,probability)

func make_gone() -> void:
	has_measured = true
	KeySprite.modulate.a = 0

func make_solid() -> void:
	has_measured = true
	is_solid = true
	KeySprite.modulate.a = 1
	var otter = get_otter()
	if (otter != null):
		make_otter_pickup_key(otter)
	elif (objects_in_hitbox.size() > 0):
		make_enemy_pickup_key(objects_in_hitbox[0])

func make_enemy_pickup_key(enemy):
	
	printerr("----Enemy pickup/inventory code not implemented: Make enemy pick up key----")
	queue_free()

func make_otter_pickup_key(_otter):
	OtterStats.inc_keys()
	queue_free()
	
func get_otter():
	for obj in objects_in_hitbox:
		if (is_object_otter(obj)):
			return obj
	return null

func is_object_otter(obj) -> bool:
	return "Otter" in obj.get_parent().get_name()

func _on_Hitbox_area_entered(area):
	objects_in_hitbox.append(area)
	if (is_solid):
		if (is_object_otter(area)):
			make_otter_pickup_key(area)
		else :
			make_enemy_pickup_key(area)

func _on_Hitbox_area_exited(area):
	objects_in_hitbox.erase(area)


func _on_Hurtbox2_area_entered(area):
	self.get_parent().in_measurement_area = true
	in_key_area = true
	OtterStats.set_measurement_area(true)


func _on_Hurtbox2_area_exited(area):
	self.get_parent().in_measurement_area = false
	in_key_area = false
	OtterStats.set_measurement_area(false)
