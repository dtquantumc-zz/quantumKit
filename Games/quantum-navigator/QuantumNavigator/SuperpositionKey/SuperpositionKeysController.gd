extends Node2D

# Script attached to the SuperpositionKeysController object
# Controls an arbitrary number of SuperpositionKeys and adjusts their
# probabilities over time

# export allows the value to be modified in inspector with type specified
export(Array,String) var Ignored_Nodes : Array = ["Timer", "Hurtbox"]
export(float) var DeadZone : float = 0
export(int) var CyclesBeforeGuarantee : int = 3
export(float) var MeasurementCutoff : float = 0.8
export(float) var ChangeSpeed : float = 6
export(float) var MinTimeBeforeRandomize : float = 2
export(float) var MaxTimeBeforeRandomize : float = 5
export(bool) var DoRandomizeRepeatedly : bool = true
export(bool) var in_measurement_area : bool = false

# Note: $<Node-name> is shorthand for get_node(<Node-name>)
onready var Timer = $Timer

var cycles_to_next_guarantee : int = CyclesBeforeGuarantee
var prev_probabilities : Array = []
var next_probabilities : Array = []
var lerp_state : float = 1
var keys : Array = []
var measured : bool = false
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
# Initializes the random number generator, locates all child keys, randomizes
# their probabilities, and starts the timer that changes probabilities
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

# Utility method to copy an array
static func arraycopy(array_one: Array) -> Array:
	return [] + array_one

# Utility method to perform linear interpolation on multiple entries in an array
static func float_array_lerp(array_one : Array, array_two : Array, amt : float) -> Array:
	amt = clamp(amt,0,1)
	if (array_one.size() != array_two.size()):
		printerr("Array size mismatch: " + str(array_one.size()) + "," + str(array_two.size()))
	var length = min(array_one.size(),array_two.size())
	var result : Array = []
	for i in range(length):
		result.append(((array_two[i]-array_one[i]) * amt) + array_one[i])
	return result

# Generates probabilities where one probability is guaranteed to be above
# the measurement cutoff
func generate_guarantee_probabilities() -> Array:
	var index = rng.randi_range(0,keys.size()-1)
	var probability_guarantee = rng.randf_range(MeasurementCutoff,1-DeadZone)
	var result : Array = []
	var floats : Array = [0.0,1-probability_guarantee]
	for i in range(keys.size()):
		if i != 0 and i != index:
			floats.append(rng.randf_range(0,1-probability_guarantee))
		if i == index:
			floats.append(floats[max(i-1,0)])
	floats.sort()
	for i in range(keys.size()):
		if i == index:
			result.append(probability_guarantee)
		else:
			result.append(floats[i+1]-floats[i])
	return result

# Generates probabilities, with no guarantee that any one will be above the
# cutoff
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

# Set current linearly-interpolated probabilities
func set_current_lerp_probabilities():
	var probabilities = float_array_lerp(prev_probabilities,next_probabilities,lerp_state)
	for i in range(keys.size()):
		keys[i].set_probability(probabilities[i])

# Call when probabilities should be randomized
# If a key should be guaranteed to be above a measurement cutoff, probabilities
# are generated to ensure that
func randomize_probabilites():
	if (cycles_to_next_guarantee == 0):
		prev_probabilities = next_probabilities
		next_probabilities = generate_guarantee_probabilities()
		lerp_state = 0
		cycles_to_next_guarantee = CyclesBeforeGuarantee
	else:
		randomize_probabilities_interpolate()
		cycles_to_next_guarantee = cycles_to_next_guarantee - 1

# Internally sets the next probabilities to linearly interpolate to
func randomize_probabilities_interpolate():
	prev_probabilities = next_probabilities
	next_probabilities = generate_probabilities()
	lerp_state = 0

# Immediately sets probabilities to randomly generated probabilities
func randomize_probabilities_immediately():
	var floats : Array = generate_probabilities()
	for i in range(keys.size()):
		keys[i].set_probability(floats[i])
	prev_probabilities = arraycopy(floats)
	next_probabilities = floats

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Updates the linearly interpolated probabilities, and makes a key solid if
# the measurement key is pressed
func _process(delta):
	if (!measured and Input.is_action_pressed("MeasureKey") and in_measurement_area):

		var measured_key
		for key in keys:
			if key.in_key_area:
				print("SuprpositionKeysController _process: " + str(key.probability))
			if key.in_key_area and key.probability > MeasurementCutoff:
				measured_key = key
				measured_key.make_solid()

		if measured_key != null:
			OtterStats.curr_main_player.measure()
			for key in keys:
				if (key != measured_key):
					key.make_gone()
			measured = true
		else:
			OtterStats.curr_main_player.measure_error()
		
	if (!measured):
		if (lerp_state < 1):
			lerp_state = clamp(lerp_state + (ChangeSpeed * delta),0,1)
			set_current_lerp_probabilities()

# Runs upon the countdown timer reaching 0
# If probabilities are supposed to be randomized, randomize probabilities
func _on_Timer_timeout():
	if (DoRandomizeRepeatedly):
		if (lerp_state == 1):
			randomize_probabilites()
		Timer.wait_time = rng.randf_range(MinTimeBeforeRandomize,MaxTimeBeforeRandomize)
	else:
		printerr("Timer on SuperpositionKeysController is running when DoRandomizeRepeatedly is false.")
		Timer.stop()
