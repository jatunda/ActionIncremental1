extends OverlappingImageDisplay

func _on_card_history_update(card_history:Array[Card]) -> void:
	clear_images()
	for card in card_history:
		var o_image : OverlappingImage = OverlappingImage.new()
		o_image.texture = card.image
		o_image.shader_material = null
		o_image.modulate = Constants.element_to_color(card.element)
		o_image.size = Vector2i(32,32)
		add_image(o_image)