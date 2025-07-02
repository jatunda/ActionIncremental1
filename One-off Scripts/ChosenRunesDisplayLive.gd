extends OverlappingImageDisplay

func _on_card_history_add_one() -> void:
	var card_state : CardState = GameplayManager.card_history[-1]
	var o_image : OverlappingImage = OverlappingImage.new()
	o_image.texture = card_state.image
	o_image.shader_material = null
	o_image.modulate = Constants.element_to_color(card_state.element)
	o_image.size = Vector2i(32,32)
	add_image(o_image)

func _on_card_history_reset() -> void:
	clear_images()
