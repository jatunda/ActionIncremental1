extends RichTextLabel

func _ready() -> void:

    # connect to signal from gameplay manager
    GameplayManager.capacity_left_changed.connect(_on_capacity_changed)
    _on_capacity_changed(GameplayManager.capacity_left)

func _on_capacity_changed(new_gems: int) -> void:
    # update the label text to show the current number of gems
    text = "capacity: " + str(new_gems) + ", "
