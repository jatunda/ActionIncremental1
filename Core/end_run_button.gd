extends Button

@export var end_run_screen : ConfirmEndRunScreen

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	self.set_process_input(false)
	end_run_screen.visible = true
	end_run_screen.mouse_filter = Control.MOUSE_FILTER_STOP
