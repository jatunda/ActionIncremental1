## pools RenderedCards
class_name RenderedCardManager
extends HBoxContainer

@export var _rendered_card_scene : PackedScene 

func render_cards(cards : Array[CardState]) -> void:

	# get current renderedCards
	var potential_rendered_cards : Array[Node] = self.get_children()
	var rendered_cards : Array[RenderedCard] = []
	for potential_rendered_card in potential_rendered_cards: 
		if potential_rendered_card is RenderedCard:
			rendered_cards.append(potential_rendered_card as RenderedCard)

	# count how many RenderedCards we are actually showing	
	var num_cards_showing : int = 0
	for rendered_card  in rendered_cards:
		if rendered_card.visible:
			num_cards_showing += 1

	# if we got too many: hide them
	if num_cards_showing > cards.size():
		var num_left_to_hide : int = num_cards_showing - cards.size()
		for i in range(rendered_cards.size() - 1, -1, -1):
			if rendered_cards[i].visible:
				rendered_cards[i].visible = false
				rendered_cards[i].card_clicked.disconnect(GameplayManager.drafting_manager._on_card_clicked)
				num_left_to_hide -= 1
				if(num_left_to_hide <= 0):
					break

	# if we got not enough: unhide or add until we got enough
	elif num_cards_showing < cards.size():
		var num_left_to_show : int = cards.size() - num_cards_showing
		# unhide
		for rendered_card in rendered_cards:
			if(rendered_card.visible == false):
				rendered_card.visible = true
				rendered_card.card_clicked.connect(GameplayManager.drafting_manager._on_card_clicked)
				num_left_to_show -= 1
				if num_left_to_show <= 0:
					break
		# add more
		for _i in range(num_left_to_show): 
			var new_rendered_card : RenderedCard = _rendered_card_scene.instantiate()
			self.add_child(new_rendered_card)
			rendered_cards.append(new_rendered_card)
			new_rendered_card.card_clicked.connect(GameplayManager.drafting_manager._on_card_clicked)

	for i in range(cards.size()):
		rendered_cards[i].spawnCard(cards[i])

	# have the cards play their initial render animations
