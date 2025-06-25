extends Button


func _ready():
	pressed.connect(SceneManager.go_to_drafting_scene)