extends Sprite2D

# TODO: Clean up hardcoded values
# TODO: All the file madness can move out of the script elsewhere

#var source_directory : String = "/home/dave/Pictures/Avatars/"
var source_directory : String = "/home/dave/Pictures/Desktops/"
var files = []
var valid_extensions = ["jpg", "png"]
var index : int = 0

func _ready():
	var dir = DirAccess.open(source_directory)
	if dir == null:
		printerr("Could not open folder.")
		return
	for file : String in dir.get_files():
		if valid_extensions.any(func(ext): return ext == file.get_extension()):
			print("match " + file.get_extension())
			files.append(file)
		else:
			print("fail  " + file.get_extension())
	files.shuffle()

# this is effectively my process forward function
# TODO: add a backward function
func _on_button_pressed() -> void:
	print(files.size(), " ", index)
	if files.size() > 0 && index < files.size():
		var image = Image.new()
		image.load(source_directory + files[index])
		var t = ImageTexture.create_from_image(image)
		texture = t
		if index < files.size() - 1:
			index += 1
	else:
		# TODO disable button on index == files.size() - 1
		print("no images or at image array end")		
