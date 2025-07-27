extends Control

var sketch: PackedScene = load("res://sketch/sketch.tscn")

# preset nodes
@onready var preset_list: OptionButton = $VBoxContainer/PresetList
@onready var save_preset_button: Button = $VBoxContainer/PresetManagerBox/SavePresetButton
@onready var delete_preset_button: Button = $VBoxContainer/PresetManagerBox/DeletePresetButton
@onready var update_preset_button: Button = $VBoxContainer/PresetManagerBox/UpdatePresetButton

# directory nodes
@onready var recursive_check: CheckBox = $VBoxContainer/HBoxContainer/RecursiveCheck
@onready var directory_label: RichTextLabel = $VBoxContainer/DirLabel
@onready var loaded_images_label: RichTextLabel = $VBoxContainer/LoadedImagesLabel

# timer nodes
@onready var timer_check: CheckBox = $VBoxContainer/TimerContainer/TimerCheck
@onready var timer_seconds_edit: LineEdit = $VBoxContainer/TimerContainer/TimerSecondsEdit
@onready var timer_warning_check: CheckBox = $VBoxContainer/WarningContainer/TimerWarningCheck
@onready var warning_time_line: LineEdit = $VBoxContainer/WarningContainer/WarningTimeLine

func _ready() -> void:
	# bind signal from popup submit to handler method
	get_node("PresetPopup").popup_submit.connect(_on_popup_submit.bind())
	DataManager.load_presets()
	populate_presets()
	populate_nodes()

# Load Preset
func _on_preset_list_item_selected(index: int) -> void:
	DataManager.preset_index = index
	DataManager.set_values_by_preset()
	DataManager.load_file_paths()
	delete_preset_button.disabled = false
	update_preset_button.disabled = false
	populate_nodes()

# Directory Selection
func _on_dir_button_pressed() -> void:
	$FileDialog.visible = true;

func _on_file_dialog_dir_selected(dir: String) -> void:
	DataManager.source_directory = dir
	directory_label.text = DataManager.source_directory
	DataManager.load_file_paths()
	set_loaded_images_label()

func _on_recursive_check_pressed() -> void:
	if DataManager.source_directory != null && DataManager.source_directory != "":
		DataManager.load_file_paths()

func set_loaded_images_label():
	if DataManager.files.size() == 1:
		loaded_images_label.text = "1 image loaded"
	elif DataManager.files.size() > 1:
		loaded_images_label.text = str(DataManager.files.size()) + " images loaded"
	else:
		loaded_images_label.text = "0 images loaded"

# Timer Management
func _on_timer_check_toggled(toggled_on: bool) -> void:
	timer_seconds_edit.editable = toggled_on
	timer_warning_check.disabled = !toggled_on
	warning_time_line.editable = toggled_on && timer_warning_check.button_pressed

func _on_timer_warning_check_toggled(toggled_on: bool) -> void:
	warning_time_line.editable = toggled_on

# Preset Management
func _on_save_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Save", 0)
	$PresetPopup.clear_title()
	$PresetPopup.visible = true

func _on_delete_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Delete", 1)
	$PresetPopup.set_title()
	$PresetPopup.visible = true

func _on_update_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Update", 2)
	$PresetPopup.set_title()
	$PresetPopup.visible = true

## Misc
func _on_start_button_pressed() -> void:
	var timer_length: int = timer_seconds_edit.text.to_int()
	var warning_length: int = warning_time_line.text.to_int()

	# prevent setting invalid times
	if timer_length < 1 || timer_length > 359999 || warning_length < 1 || warning_length > 59:
		return

	if DataManager.files != []:
		DataManager.set_values(
			recursive_check.button_pressed,
			timer_check.button_pressed,
			timer_warning_check.button_pressed,
			timer_length,
			warning_length
		)
		DataManager.files.shuffle()
		get_tree().change_scene_to_packed(sketch)

func populate_nodes() -> void:
	directory_label.text = DataManager.source_directory
	recursive_check.button_pressed = DataManager.recursive_check
	timer_check.button_pressed = DataManager.run_timer
	timer_warning_check.button_pressed = DataManager.timer_warning
	timer_seconds_edit.text = str(DataManager.timer_length)
	warning_time_line.text = str(DataManager.warning_length)
	warning_time_line.editable = timer_warning_check.button_pressed
	set_loaded_images_label()
	$VBoxContainer/VersionLabel.text = "Timed Skecthes - " + DataManager.VERSION
func populate_presets() -> void:
	preset_list.clear()
	if DataManager.presets:
		for i in range(DataManager.presets.size()):
			preset_list.add_item(DataManager.presets[i]["title"])
		preset_list.select(DataManager.preset_index)

	if preset_list.selected == -1:
		delete_preset_button.disabled = true
		update_preset_button.disabled = true
	else:
		delete_preset_button.disabled = false
		update_preset_button.disabled = false

func _on_popup_submit(title: String, mode: int, submit: bool) -> void:
	$PresetPopup.visible = false
	if !submit:
		return

	var timer_length: int = timer_seconds_edit.text.to_int()
	var warning_length: int = warning_time_line.text.to_int()

	match mode:
		0: # save logic
			if (
				title == "" ||
				DataManager.files == [] ||
				timer_length < 1 ||
				timer_length > 35999 ||
				warning_length < 1 ||
				warning_length > 59
			):
				return
			DataManager.set_values(
				recursive_check.button_pressed,
				timer_check.button_pressed,
				timer_warning_check.button_pressed,
				timer_length,
				warning_length

			)
			DataManager.save_preset(title)
			populate_presets()
		1: # delete logic
			DataManager.delete_preset()
			populate_presets()
			populate_nodes()
		2: # update logic
			if (
				title == "" ||
				DataManager.files == [] ||
				timer_length < 1 ||
				timer_length > 35999 ||
				warning_length < 1 ||
				warning_length > 59
			):
				return
			DataManager.set_values(
				recursive_check.button_pressed,
				timer_check.button_pressed,
				timer_warning_check.button_pressed,
				timer_length,
				warning_length
			)
			DataManager.update_preset(title);
			populate_presets()
