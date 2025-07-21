## V1 Requirements

Session Setup
	- save configuration
	- update configuration
	- delete configuration

I need to figure out what my configuration set up is going to look like.

```json
[
	{
		"title": "string",
		"source_directory": "string",
		"load_recursive": "bool",
		"enable_timer": "bool",
		"timer_warning": "bool",
		"timer_length": "int"
	},
	{ ... }
]
```

- this will require checking for or creating the file on start up
- sketch_config.json

	- launch from vs code

## V2 Optional Features
Session Setup
	- number of images to study -> to limit study session
Timed Sketch View
	- show the number of files/current file