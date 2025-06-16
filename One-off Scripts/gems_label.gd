extends RichTextLabel

func _ready() -> void:

    # connect to signal from gameplay manager
    GameplayManager.gems_changed.connect(_on_gems_changed)
    _on_gems_changed(GameplayManager.gems)

func _on_gems_changed(new_gems: int) -> void:
    # update the label text to show the current number of gems
    text = "Gems: " + str(new_gems)
