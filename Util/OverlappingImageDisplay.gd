

class_name OverlappingImageDisplay
extends Control

@export var image_overlap_x : int = 10
@export var image_overlap_y : int = 0
var image_data: Array[OverlappingImage] = []
var layout: Array = []

var wrap_width: int:
	get: return int(size.x)

func add_image(image : OverlappingImage) -> void:
	image_data.append(image)
	layout = compute_layout()
	queue_redraw()

func clear_images() -> void:
	image_data.clear()
	layout.clear()
	queue_redraw()

func _ready():
	image_data = []
	layout = compute_layout()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		layout = compute_layout()
		queue_redraw()

func compute_layout() -> Array:
	var result = []
	var x = 0
	var y = 0
	var row_height = 0

	for img in image_data:
		var tex: Texture2D = img.texture
		if tex == null:
			continue

		var img_size: Vector2i = img.size

		if x + img_size.x > wrap_width and x > 0:
			x = 0
			y += row_height - image_overlap_y
			row_height = 0

		img.position = Vector2(x,y)
		result.append(img)

		x += img_size.x - image_overlap_x
		row_height = max(row_height, img_size.y)
		custom_minimum_size = Vector2(size.x, y+row_height)

	return result

func _draw():
	for item in layout:
		var tex: Texture2D = item.texture
		if tex == null:
			continue

		var pos: Vector2 = item.position
		var shader: ShaderMaterial = item.shader_material
		var img_modulate: Color = item.modulate
		var img_size: Vector2 = Vector2(item.size)

		if shader:
			material = shader

		draw_texture_rect(tex, Rect2(pos, img_size), false, img_modulate)
		
		if shader:
			material = null
