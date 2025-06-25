class_name RunSummary
extends Control

signal start_new_run()

@onready var start_new_run_button : Button = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/StartNewRunButton
@onready var upgrades_screen_button : Button = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradesScreneButton

func _ready() -> void:
	start_new_run_button.pressed.connect(_on_start_new_run_button_pressed)
	upgrades_screen_button.pressed.connect(_on_upgrades_screen_button_pressed)

func _on_start_new_run_button_pressed() -> void:
	start_new_run.emit()

func _on_upgrades_screen_button_pressed() -> void:
	SceneManager.go_to_upgrades_scene()