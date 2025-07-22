# Timed Sketches

This is a quick and dirty application that will load images from a specified folder, randomize the order of those files, and then display them against a timer a timed reference for drawing.

It is very barebones and written to be a slim application for my personal use. I've made no efforts to make this functional for others, though it should be useable "out of the box" given that I'm using default Godot functionality for everything.

### Session Setup

The application loads into the session setup view. This allows the user to select the source images folder. There is a toggle to get images recursively. This is useful if reference images are sorted into different folders and the study session is more open subject.

Set the timer length for how long an image should be displayed. This can be set as low as one second or as high as 359999 (99 hours, 59 minutes, and 59 seconds). A reasonable number is probably somewhere between 10 and 3600 seconds (1 hour).

The timer can be disabled. This will prevent images from auto advancing in the timed sketch view. Images can be changes by using the keyboard inputs listed below.

Sessions can be saved and loaded again in the future. Session preset management allows saving, editing, and deleting presets.

Once a valid source folder has been selected the start button will launch the timed sketch session.

### Timed Sketch View

Once started the application moves to automatically loading images. If the timer is enabled, it will automatically load the next image when the timer expires, resetting the timer for the new image. This will continue until all images have been displayed or the user exits the application.

The user can advance images manually or go backward through the list using keyboard inputs. Ther time will reset every time the image is changed.

If the timer is not enabled, images will not auto advance. The user can manually advance images or go back through the list using keyboard inputs.

Keyboard Inputs:

- move forward an image - right arrow
- move back an image - left arrow
- pause/resume timer - space bar
- return to config screen - q

### Future Feature Considerations

- add vs code debug profile (for my own convenience)
- Session Setup
	- number of images to study -> to limit study session
- Timed Sketch View
	- show the number of files/current file