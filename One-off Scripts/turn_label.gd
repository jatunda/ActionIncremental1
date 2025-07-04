extends RichTextLabel

func _ready() -> void:
	# connect to signal from gameplay manager
	GameplayManager.drafting_manager.on_turn_number_change.connect(_on_turn_number_changed)
	_on_turn_number_changed()

func _on_turn_number_changed() -> void:
	# update the label text to show the current number of gems
	text = "turn: %s, " % [GameplayManager.drafting_manager.turn_number]
