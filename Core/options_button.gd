## Button to be put into scenes where you want the options screen to pop up when clicked.
class_name OptionsButton
extends Button

@export var should_display_quit_game = true
@export var should_display_return_to_start_screen = true
@export var should_confirm_leaving_scene = true

@export_group("internal references")
@export var popup : PopupPanel
@export var return_to_title_screen_button : Button
@export var return_to_title_dialog : ConfirmationDialog
@export var quit_game_button : Button
@export var quit_game_dialog : ConfirmationDialog
@export var close_options_button : Button 

var was_popup_open_on_button_down:bool

func _ready() -> void:
	button_down.connect(_on_button_down)
	pressed.connect(open_options)
	return_to_title_screen_button.pressed.connect(_on_return_to_title_button_pressed)
	quit_game_button.pressed.connect(_on_quit_game_button_pressed)
	close_options_button.pressed.connect(close_options)
	quit_game_dialog.confirmed.connect(quit_game)

	return_to_title_screen_button.visible = should_display_return_to_start_screen


func _on_quit_game_button_pressed() -> void:
	if should_confirm_leaving_scene:
		show_quit_confirmation()
	else:
		quit_game()

func _on_button_down() -> void:
	was_popup_open_on_button_down = popup.visible

func open_options() -> void:
	if not was_popup_open_on_button_down:
		popup.visible = true
	was_popup_open_on_button_down = false

func close_options() -> void:
	popup.visible = false

func show_quit_confirmation() -> void:
	quit_game_dialog.visible = true

func quit_game() -> void:
	get_tree().quit()

func show_return_to_title_dialog() -> void:
	return_to_title_dialog.visible = true

func _on_return_to_title_button_pressed() -> void:
	if should_confirm_leaving_scene:
		show_return_to_title_dialog()
	else:
		return_to_title_screen()

func return_to_title_screen() -> void:
	SceneManager.go_to_start_scene()
