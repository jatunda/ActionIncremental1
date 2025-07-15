class_name ConfirmEndRunScreen
extends Control

signal end_run_pressed
signal continue_run_pressed

@onready var my_end_run_button : Button = $Panel/CenterContainer/Panel/VBoxContainer/HBoxContainer/EndRunButton
@onready var my_continue_run_button : Button = $Panel/CenterContainer/Panel/VBoxContainer/HBoxContainer/ContinueRunButton

func _ready() -> void:
	my_end_run_button.pressed.connect(_on_end_run_pressed)
	my_continue_run_button.pressed.connect(_on_continue_run_pressed)

func enable_screen() -> void:
	self.visible = true
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	my_end_run_button.disabled = false
	my_continue_run_button.disabled = false

func disable_screen() -> void:
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	my_end_run_button.disabled = true
	my_continue_run_button.disabled = true


func _on_end_run_pressed() -> void:
	end_run_pressed.emit()
	disable_screen()
	pass

func _on_continue_run_pressed() -> void:
	continue_run_pressed.emit()
	disable_screen()
	pass
		
