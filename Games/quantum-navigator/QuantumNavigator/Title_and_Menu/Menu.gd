extends Node2D

var MenuItems = ["Start_Item", "Exit_Item"]
var Selected = 0

export(PackedScene) var startScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_selection(val):
	print(val)
	if Selected == val: return
	get_node(MenuItems[Selected]).animation = "Static"
	get_node(MenuItems[val]).animation = "Selected"
	$Selection_Particle.position = get_node(MenuItems[val]).position - Vector2(7*8, 0)
	Selected = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var newselect = Selected
	if Input.is_action_just_pressed("ui_up"):
		newselect -= 1
		newselect += MenuItems.size()
		newselect %= MenuItems.size()
	if Input.is_action_just_pressed("ui_down"):
		newselect += 1
		newselect %= MenuItems.size()
	set_selection(newselect)
	if Input.is_action_just_pressed("ui_accept"):
		if Selected == 0 and startScene != null:
			get_tree().change_scene_to(startScene)
			OtterStats.reset()
		else:
			get_tree().quit()
