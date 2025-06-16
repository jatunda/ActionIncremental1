extends RichTextLabel

func _ready() -> void:

    # connect to signal from gameplay manager
    GameplayManager.draws_left_changed.connect(_on_draws_left_changed)
    _on_draws_left_changed(GameplayManager.draws_left)

func _on_draws_left_changed(new_gems: int) -> void:
    # update the label text to show the current number of gems
    text = "draws left: " + str(new_gems) + ", "
