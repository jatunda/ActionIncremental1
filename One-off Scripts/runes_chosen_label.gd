extends RichTextLabel

func _ready() -> void:
	GameplayManager.card_history_update.connect(_on_card_history_update)
	_on_card_history_update(GameplayManager.card_history)

func _on_card_history_update(cards: Array[Card]) -> void:
	var output : String = "Runes Chosen: " 
	for card in cards:
		var img_path = card.image.resource_path
		var color = str(Constants.element_to_color(card.element).to_html())
		output += "[img width=32 color=" + color + "]" 
		#output += "[img width=32 color=ff0000]"
		output += img_path 
		output += "[/img]"
	text = output

