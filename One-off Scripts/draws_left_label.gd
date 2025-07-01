extends RichTextLabel

func _ready() -> void:

	# connect to signal from gameplay manager
	GameplayManager.time_left_updated.connect(_on_time_left_changed)
	_on_time_left_changed()

func _on_time_left_changed() -> void:
	# update the label text to show the current number of gems
	text = "time left: %s, " % [GameplayManager.time_left]
