extends OptionButton

var resolutions : Dictionary[String,Vector2] = {
	"640x360":Vector2(640,360),
	"1280x720":Vector2(1280,720),
	"1920x1080":Vector2(1920,1080),
	"2460x1440":Vector2(2460,1440),
	"3200x1800":Vector2(3200,1800),
	"3840x2160":Vector2(3840,2160),
}

func _ready() -> void:
	for resolution : String in resolutions:
		self.add_item(resolution)
	item_selected.connect(_on_item_selected)

func _process(_delta: float) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		disabled = true
	else:
		disabled = false

func _on_item_selected(index:int) -> void:
	var key:String = get_item_text(index)
	get_tree().get_root().set_size(resolutions[key])
	get_tree().get_root().move_to_center()
	
