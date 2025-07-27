extends TextureRect

var image: Image = Image.new()
var index: int = 0
var session: PackedScene = load("res://session/session.tscn")
var warning_triggered: bool = false

@export var timer:Timer

func _ready():
	load_image()
	if DataManager.run_timer:
		timer.wait_time = DataManager.timer_length
		timer.start()
		%TimerText.visible = true
	else:
		%TimerText.visible = false

func _process(_delta: float) -> void:
	if DataManager.run_timer and timer.is_stopped() == false:
		var r_time = int(ceil(timer.time_left))
		@warning_ignore("integer_division")
		var hours = r_time / 3600
		r_time -= hours * 3600
		@warning_ignore("integer_division")
		var minutes = r_time / 60
		r_time -= minutes * 60
		var seconds = r_time
		var formatted_time = "%02d" % [hours] + ":" + "%02d" % [minutes] + ":" + "%02d" % [seconds]
		%TimerText.text = formatted_time
		# play 10 second warning sound
		if !warning_triggered && hours == 0 && minutes == 0 && seconds == DataManager.warning_length:
			$'../WarningTone'.play()
			warning_triggered = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.get_keycode():
			32: #space
				if DataManager.run_timer:
					timer.paused = !timer.paused
			81: # Q
				get_tree().change_scene_to_packed(session)
			4194319: # left arrow
				prev_image()
			4194321: # right arrow
				next_image()

func load_image() -> void:
	image.load(DataManager.files[index])
	var window_size:Vector2 = get_viewport().size
	var image_size:Vector2 = image.get_size()
	var image_transform:Vector2 = window_size / image_size
	var scale_value = min(image_transform.x, image_transform.y)
	image.resize(image_size.x * scale_value, image_size.y * scale_value)
	texture = ImageTexture.create_from_image(image)
	if DataManager.run_timer:
		timer.start()
		warning_triggered = false

func next_image() -> void:
	if DataManager.files.size() > 0 && index < DataManager.files.size() - 1:
		index += 1
		load_image()

func prev_image() -> void:
	if index > 0:
		index -= 1
		load_image()

func _on_timer_timeout() -> void:
	if index == DataManager.files.size() - 1:
		timer.stop()
		%TimerText.text = "END"
	else:
		next_image()
