extends Button

func _ready() -> void:
	GameplayManager.skips_changed.connect(_on_skips_changed)

func _on_skips_changed(new_skips : int) -> void:
	if new_skips <= 0:
		disabled = true
		text = "No skips left"
	else:
		disabled = false
		text = "Skip (%s left)" % new_skips