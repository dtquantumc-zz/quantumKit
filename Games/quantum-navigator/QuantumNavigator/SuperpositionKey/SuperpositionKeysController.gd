extends Node2D

export(Array,String) var Ignored_Nodes : Array = ["Timer", "Hurtbox"]
export(float) var DeadZone : float = 0.1
export(bool) var IsActive : bool = false
export(float) var ChangeSpeed : float = 0.05
export(float) var MinTimeBeforeRandomize : float = 2
export(float) var MaxTimeBeforeRandomize : float = 5
export(bool) var DoRandomizeRepeatedly : bool = true

onready var Timer = $Timer

var prev_probabilities : Array = []
var next_probabilities : Array = []
var lerp_state : float = 0
export var in_measurement_area = false

var keys : Array = []
# Called when the node enters the scene tree for the first time.

var measured : bool = false
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if DoRandomizeRepeatedly:
		Timer.wait_time = rng.randf_range(MinTimeBeforeRandomize,MaxTimeBeforeRandomize)
		Timer.start()
	var children = get_children()
	for child in children:
		if (!(child.name in Ignored_Nodes)):
			keys.append(child)
	randomize_probabilities_immediately()

static func arraycopy(array_one: Array) -> Array:
	return [] + array_one

static func float_array_lerp(array_one : Array, array_two : Array, amt : float) -> Array:
	amt = clamp(amt,0,1)
	if (array_one.size() != array_two.size()):
		printerr("Array size mismatch: " + str(array_one.size()) + "," + str(array_two.size()))
	var length = min(array_one.size(),array_two.size())
	var result : Array = []
	for i in range(length):
		result.append(((array_two[i]-array_one[i]) * amt) + array_one[i])
	return result

func generate_probabilities() -> Array:
	var floats : Array = [0.0,1.0]
	var result : Array = []
	var is_first : bool = false
	for key in keys:
		if !is_first:
			is_first = true
		else:
			# Note: this guarantees that no key will have a probability of 1
			#       but does not guarantee that a key will have a probability of
			#       a value near 0
			floats.append(rng.randf_range(DeadZone,1-DeadZone))
	floats.sort()
	for i in range(keys.size()):
		result.append(floats[i+1]-floats[i])
	return result

func set_current_lerp_probabilities():
	var probabilities = float_array_lerp(prev_probabilities,next_probabilities,lerp_state)
	for i in range(keys.size()):
		keys[i].set_probability(probabilities[i])

func randomize_probabilities_interpolate():
	prev_probabilities = next_probabilities
	next_probabilities = generate_probabilities()
	lerp_state = 0

func randomize_probabilities_immediately():
	var floats : Array = generate_probabilities()
	for i in range(keys.size()):
		keys[i].set_probability(floats[i])
	prev_probabilities = arraycopy(floats)
	next_probabilities = floats

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!measured and Input.is_action_pressed("MeasureKey") and in_measurement_area):
		var value = rng.randf_range(0,1)
		var solid_set : bool = false
		for key in keys:
			if (value > key.probability):
				key.make_gone()
				value -= key.probability
			elif !solid_set:
				key.make_solid()
				solid_set = true
			else:
				key.make_gone()
		measured = true
	if (!measured):
		if (lerp_state < 1):
			lerp_state = clamp(lerp_state + ChangeSpeed,0,1)
			set_current_lerp_probabilities()

func _on_Timer_timeout():
	if (DoRandomizeRepeatedly):
		randomize_probabilities_interpolate()
		Timer.wait_time = rng.randf_range(MinTimeBeforeRandomize,MaxTimeBeforeRandomize)
	else:
		printerr("Timer on SuperpositionKeysController is running when DoRandomizeRepeatedly is false.")
		Timer.stop()
