extends RichTextLabel

func _ready() -> void:

	# connect to signal from gameplay manager
	GameplayManager.draws_left_updated.connect(_on_draws_left_changed)
	_on_draws_left_changed()

func _on_draws_left_changed() -> void:
	# update the label text to show the current number of gems
	text = "draws left: %s, " % [GameplayManager.draws_left]
