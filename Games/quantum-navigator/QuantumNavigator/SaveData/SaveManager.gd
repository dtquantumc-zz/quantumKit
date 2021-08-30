extends Node

# Script attached to the SaveManger that handles player save games

onready var save_path : String = "user://qn.save"

# Saves the current level number and scene to a save file
# TODO: Find a better way to get a level scene's path
# (Maybe a Level Manager that maps a level number to its path?)
func save_progress(level_scene_path):
	var save_data = {
		"level_number" : OtterStats.curr_level,
		"level_scene" : level_scene_path
	}
	print('saved')
	print(save_data)
	var save_file = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()


# Returns a JSON containing saved information
func load_progress():
	var save_file = File.new()
	if not save_file.file_exists(save_path):
		return
		
	save_file.open(save_path, File.READ)
	var save_data = parse_json(save_file.get_as_text())
	print(save_data)
	return save_data
	
# Returns true if information in a given save data JSON is valid, false otherwise
func validate_save_data(save_data):
	if !save_data.has("level_number") || !save_data.has("level_scene"):
		return false
#	if save_data["level_scene"] != null && !ResourceLoader.exists(save_data["level_scene"]):
#		return false
	return true
	
# Gets the save file path
func get_save_file_path() -> String:
	return save_path
