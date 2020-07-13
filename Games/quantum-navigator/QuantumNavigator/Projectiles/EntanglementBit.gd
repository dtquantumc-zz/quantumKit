extends Area2D

const FIREBALL_SPEED = 200
var direction = null

func start(_direction):
	direction = _direction

func _process(delta):
	var speed_x = 1
	var speed_y = 0
	var motion = direction * FIREBALL_SPEED
	
	set_global_position(get_global_position() + motion * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_EntanglementBit_area_entered(area):
	queue_free()
	area.queue_free()  # destroy target
