extends Area2D

const ENTANGLEMENT_BIT_SPEED = 200
const UTIL = preload("res://Utility.gd")

var direction = null
var color = UTIL.BLUE
func start(_direction, _color):
	direction = _direction
	color = _color
	if color == UTIL.BLUE:
		var blueBit = load("res://UI/BlueEntanglementBitFull.png")
		get_node("Sprite").set_texture(blueBit)

func _process(delta):
	var motion = direction * ENTANGLEMENT_BIT_SPEED
	set_global_position(get_global_position() + motion * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_EntanglementBit_area_entered(_area):
	queue_free()
	CustomSignals.emit_signal("entanglement_bit_collision", color)
	if color == UTIL.RED:
		OtterStats.red_bits -= 1
	else:
		OtterStats.blue_bits -= 1
