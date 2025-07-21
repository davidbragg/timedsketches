extends ColorRect

signal popup_submit(title: String, mode: int, submit: bool)

var mode: int

func clear_title() -> void:
	$ColorRect/VBoxContainer/TitleLineEdit.text = ""

func set_mode(caption: String, mode_val: int) -> void:
	mode = mode_val
	$ColorRect/VBoxContainer/HBoxContainer/OkButton.text = caption

func set_title() -> void:
	$ColorRect/VBoxContainer/TitleLineEdit.text = DataManager.presets[DataManager.preset_index]["title"]

func _on_cancel_button_pressed() -> void:
	var title = $ColorRect/VBoxContainer/TitleLineEdit.text
	popup_submit.emit(title, mode, false)


func _on_ok_button_pressed() -> void:
	var title = $ColorRect/VBoxContainer/TitleLineEdit.text
	popup_submit.emit(title, mode, true)
