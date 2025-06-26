extends Button

func _ready() -> void:
	GameplayManager.skips_updated.connect(_on_skips_changed)

func _on_skips_changed() -> void:
	var new_skips : int = GameplayManager.skips
	if new_skips <= 0:
		disabled = true
		text = "No skips left"
	else:
		disabled = false
		text = "Skip (%s left)" % new_skips
