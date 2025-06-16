extends Label

func _ready() -> void:
	StatusManager.on_status_update.connect(self.on_status_update)

func on_status_update(new_active_statuses : Array[Status]) -> void:
	var output : String = "Status: "
	for status in new_active_statuses:
		output += status.debug_text + ", "
	text = output
