class_name RunSummary
extends Control

signal start_new_run()

@onready var start_new_run_button : Button = $MarginContainer/MarginContainer/VBoxContainer/StartNewRunButton

func _ready() -> void:
	start_new_run_button.pressed.connect(_on_start_new_run_button_pressed)

func _on_start_new_run_button_pressed() -> void:
	start_new_run.emit()
