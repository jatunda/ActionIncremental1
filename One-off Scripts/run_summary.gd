class_name RunSummary
extends Control

signal start_new_run()

@export_group("internal links")
@export var end_run_reason_label : Label
@export var num_runes_invoked_label : Label 
@export var runes_image_display : OverlappingImageDisplay
@export var gems_this_run_label : Label 
@export var gems_total_label : Label 
@onready var start_new_run_button : Button = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/StartNewRunButton
@onready var upgrades_screen_button : Button = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradesScreneButton

func _ready() -> void:
	start_new_run_button.pressed.connect(_on_start_new_run_button_pressed)
	upgrades_screen_button.pressed.connect(_on_upgrades_screen_button_pressed)

func _on_start_new_run_button_pressed() -> void:
	start_new_run.emit()

func _on_upgrades_screen_button_pressed() -> void:
	SceneManager.go_to_upgrades_scene()

func enable_screen(reason : Constants.EndRunReason) -> void:
	# actually enable screen
	show()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# fill in the reason for ending the run
	match reason:
		Constants.EndRunReason.OUT_OF_TIME:
			end_run_reason_label.text = "Ran out of time"
		Constants.EndRunReason.MANUAL_END:
			end_run_reason_label.text = "Manually ended the run"
		Constants.EndRunReason.WALL_CLEARED:
			end_run_reason_label.text = "Broke through the wall"
		_:
			end_run_reason_label.text = "Run Ended"

	# runes display nice and pretty
	runes_image_display.clear_images()
	for card_state: CardState in GameplayManager.card_history:
		var o_image : OverlappingImage = OverlappingImage.new()
		o_image.texture = card_state.image
		o_image.shader_material = null
		o_image.modulate = Constants.element_to_color(card_state.element)
		o_image.size = Vector2i(32,32)
		runes_image_display.add_image(o_image)
		pass

	# number of runes invoked
	num_runes_invoked_label.text = "Runes Invoked: %s" % GameplayManager.card_history.size()

	# gems this run
	gems_this_run_label.text = "Gems Earned: %s" % GameplayManager.gems_this_run[Constants.GemTier.TIER1]
	
	# gems total
	gems_total_label.text = "Total Gems: %s" % GameplayManager.gems_total[Constants.GemTier.TIER1]

func disable_screen() -> void:
	hide()
	mouse_filter = Control.MOUSE_FILTER_STOP
