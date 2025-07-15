class_name ConfirmEndRunScreen
extends Control

signal end_run_pressed

@onready var my_end_run_button : Button = $Panel/CenterContainer/Panel/VBoxContainer/HBoxContainer/EndRunButton
@onready var my_continue_run_button : Button = $Panel/CenterContainer/Panel/VBoxContainer/HBoxContainer/ContinueRunButton

func _ready() -> void:
	my_end_run_button.pressed.connect(_on_end_run_pressed)
	my_continue_run_button.pressed.connect(_on_continue_run_pressed)

func _on_end_run_pressed() -> void:
	end_run_pressed.emit()
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass

func _on_continue_run_pressed() -> void:
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass
		
