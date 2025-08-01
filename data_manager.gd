extends Node

const VERSION: String = "0.1.1"
const WARNING_LENGTH: int = 10

var valid_extensions: Array[String] = ["jpg", "png"]
var preset_file: String = "user://presets.json"

var files: Array[String] = []
var source_directory: String = "no directory selected"
var presets: Array

var run_timer: bool = true
var timer_warning: bool = true
var recursive_check: bool = false

var timer_length: int = 300
var warning_length: int = WARNING_LENGTH
var preset_index: int = -1

# File Management
func load_file_paths() -> void:
	DataManager.files = []
	var dir = DirAccess.open(DataManager.source_directory)
	if dir == null:
		printerr("Could not open folder.")
		return

	# load files from nested folders
	if recursive_check:
		files = load_file_paths_recursive(source_directory)
	# load files only from selected folder
	else:
		for file:String in dir.get_files():
			if valid_extensions.any(func(ext): return ext == file.get_extension()):
				DataManager.files.append(DataManager.source_directory + "/" + file)

func load_file_paths_recursive(dir_path: String) -> Array[String]:
	var dir_files: Array[String] = []
	var item_path: String
	# open the source folder
	var dir = DirAccess.open(dir_path)
	if dir == null:
		printerr("Could not open folder.")
		return dir_files
	# iterate through the folder
	dir.list_dir_begin()
	var item = dir.get_next()
	while item != "":
		item_path = dir_path + "/" + item
		if dir.dir_exists(item_path):
			dir_files.append_array(load_file_paths_recursive(item_path))
		if dir.file_exists(item_path) && valid_extensions.any(func(ext): return ext == item_path.get_extension()):
			dir_files.append(item_path)
		item = dir.get_next()
	dir.list_dir_end()

	return dir_files

# Manage Values
func set_values_by_preset() -> void:
	var selected_preset = presets[preset_index]
	source_directory = selected_preset["source_directory"]
	recursive_check = selected_preset["load_recursive"]
	run_timer = selected_preset["enable_timer"]
	timer_warning = selected_preset["timer_warning"]
	timer_length = selected_preset["timer_length"]
	# support presets created in previous versions
	if selected_preset.has("warning_length"):
		warning_length = selected_preset["warning_length"]
	else:
		warning_length = WARNING_LENGTH

func set_values(recursive_bool: bool, timer_bool: bool, warning_bool: bool, timer_int: int, warning_int: int):
	recursive_check = recursive_bool
	run_timer = timer_bool
	timer_warning = warning_bool
	timer_length = timer_int
	warning_length = warning_int

func reset_values() -> void:
	files = []
	run_timer = true
	timer_warning = true
	recursive_check = false
	source_directory = "no directory selected"
	timer_length = 300
	warning_length = WARNING_LENGTH
	preset_index = -1

# Manage Presets
func load_presets() -> void:
	if FileAccess.file_exists(preset_file):
		var json_as_text = FileAccess.get_file_as_string(preset_file)
		presets = JSON.parse_string(json_as_text)

func delete_preset() -> void:
	presets.remove_at(preset_index)
	save_presets()
	reset_values()

func save_preset(title: String) -> void:
	presets.append(make_preset(title))
	preset_index = presets.size() - 1
	save_presets()

func update_preset(title: String) -> void:
	presets[preset_index] = make_preset(title)
	save_presets()

func save_presets() -> void:
	var file = FileAccess.open(preset_file, FileAccess.WRITE)
	var json_string = JSON.stringify(presets)
	file.store_string(json_string)
	file.close()

func make_preset(title: String) -> Dictionary:
	var preset_dict: Dictionary = {
		"title": title,
		"source_directory": source_directory,
		"load_recursive": recursive_check,
		"enable_timer": run_timer,
		"timer_warning": timer_warning,
		"timer_length": timer_length,
		"warning_length": warning_length
	}
	return preset_dict
