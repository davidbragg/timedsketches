extends Control

var sketch: PackedScene = load("res://sketch/sketch.tscn")

func _ready() -> void:
	get_node("PresetPopup").popup_submit.connect(_on_popup_submit.bind())
	DataManager.load_presets()
	populate_presets()
	populate_nodes()

func _on_start_button_pressed() -> void:
	var timer_length: int = $VBoxContainer/TimerSetContainer/TimerSecondsEdit.text.to_int()
	if timer_length < 1 || timer_length > 359999:
		return
	if DataManager.files != []:
		DataManager.set_values(
			$VBoxContainer/HBoxContainer/RecursiveCheck.button_pressed,
			$VBoxContainer/TimerCheckContainer/TimerCheck.button_pressed,
			$VBoxContainer/TimerCheckContainer/TimerWarningCheck.button_pressed,
			timer_length
		)
		DataManager.files.shuffle()
		get_tree().change_scene_to_packed(sketch)

func _on_dir_button_pressed() -> void:
	$FileDialog.visible = true;

func _on_file_dialog_dir_selected(dir: String) -> void:
	DataManager.source_directory = dir
	$VBoxContainer/DirLabel.text = DataManager.source_directory
	DataManager.load_file_paths()
	set_loaded_images_label()

func _on_recursive_check_pressed() -> void:
	if DataManager.source_directory != null && DataManager.source_directory != "":
		DataManager.load_file_paths()

func _on_preset_list_item_selected(index: int) -> void:
	DataManager.preset_index = index
	DataManager.set_values_by_preset()
	DataManager.load_file_paths()
	$VBoxContainer/PresetManagerBox/DeletePresetButton.disabled = false
	$VBoxContainer/PresetManagerBox/UpdatePresetButton.disabled = false
	populate_nodes()

func _on_save_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Save", 0)
	$PresetPopup.clear_title()
	$PresetPopup.visible = true

func populate_nodes() -> void:
	$VBoxContainer/DirLabel.text = DataManager.source_directory
	$VBoxContainer/HBoxContainer/RecursiveCheck.button_pressed = DataManager.recursive_check
	$VBoxContainer/TimerCheckContainer/TimerCheck.button_pressed = DataManager.run_timer
	$VBoxContainer/TimerCheckContainer/TimerWarningCheck.button_pressed = DataManager.timer_warning
	$VBoxContainer/TimerSetContainer/TimerSecondsEdit.text = str(DataManager.timer_length)
	set_loaded_images_label()

func populate_presets() -> void:
	$VBoxContainer/PresetList.clear()
	if DataManager.presets:
		for i in range(DataManager.presets.size()):
			$VBoxContainer/PresetList.add_item(DataManager.presets[i]["title"])
		$VBoxContainer/PresetList.select(DataManager.preset_index)
	if $VBoxContainer/PresetList.selected != -1:
		$VBoxContainer/PresetManagerBox/DeletePresetButton.disabled = false
		$VBoxContainer/PresetManagerBox/UpdatePresetButton.disabled = false


func set_loaded_images_label():
	if DataManager.files.size() == 1:
		$VBoxContainer/LoadedImagesLabel.text = "1 image loaded"
	elif DataManager.files.size() > 1:
		$VBoxContainer/LoadedImagesLabel.text = str(DataManager.files.size()) + " images loaded"
	else:
		$VBoxContainer/LoadedImagesLabel.text = "0 images loaded"


func _on_delete_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Delete", 1)
	$PresetPopup.set_title()
	$PresetPopup.visible = true



func _on_update_preset_button_pressed() -> void:
	$PresetPopup.set_mode("Update", 2)
	$PresetPopup.set_title()
	$PresetPopup.visible = true


func _on_popup_submit(title: String, mode: int, submit: bool) -> void:
	$PresetPopup.visible = false
	if !submit:
		return

	var timer_length: int = $VBoxContainer/TimerSetContainer/TimerSecondsEdit.text.to_int()

	match mode:
		0: # save logic
			if title == "" ||  DataManager.files == [] || timer_length < 1 || timer_length > 35999:
				return

			print("In Save Preset")
			DataManager.set_values(
				$VBoxContainer/HBoxContainer/RecursiveCheck.button_pressed,
				$VBoxContainer/TimerCheckContainer/TimerCheck.button_pressed,
				$VBoxContainer/TimerCheckContainer/TimerWarningCheck.button_pressed,
				timer_length
			)
			DataManager.save_preset(title)
			populate_presets()

			# update the option list and set to current index
		1: # update logic
			if title == "" ||  DataManager.files == [] || timer_length < 1 || timer_length > 35999:
				return
			print("In Update Preset")
			DataManager.set_values(
				$VBoxContainer/HBoxContainer/RecursiveCheck.button_pressed,
				$VBoxContainer/TimerCheckContainer/TimerCheck.button_pressed,
				$VBoxContainer/TimerCheckContainer/TimerWarningCheck.button_pressed,
				timer_length
			)
			# Datamanager.update_preset(title) -> should have index saved in DataManager
			# update the option list and set to current index
		2: # delete logic
			print("In Delete Preset")
			# DataManager.delete_preset() -> should ahve index saved in DataManager
			# update the option list
			# clear option list setting
