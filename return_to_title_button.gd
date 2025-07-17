extends Button

func _ready() -> void:
	pressed.connect(return_to_title)

func return_to_title() -> void:
	SceneManager.go_to_start_scene()