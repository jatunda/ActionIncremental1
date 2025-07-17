extends CheckButton

func _ready() -> void:
	toggled.connect(_on_toggle)

func _on_toggle(toggled_on:bool):
	
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
