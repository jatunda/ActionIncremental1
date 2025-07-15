class_name EndRunButton
extends Button

@export var end_run_screen : ConfirmEndRunScreen

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	end_run_screen.end_run_pressed.connect(disable_button)
	end_run_screen.continue_run_pressed.connect(enable_button)

func enable_button() -> void:
	self.disabled = false
	pass


func disable_button() -> void:
	self.disabled = true
	pass

func _on_pressed() -> void:
	disable_button()
	end_run_screen.enable_screen()
