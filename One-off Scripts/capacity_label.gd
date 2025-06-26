extends RichTextLabel

func _ready() -> void:

	# connect to signal from gameplay manager
	GameplayManager.capacity_left_updated.connect(_on_capacity_changed)
	_on_capacity_changed()

func _on_capacity_changed() -> void:
	# update the label text to show the current number of gems
	text = "capacity: %s, " % [GameplayManager.capacity_left]
