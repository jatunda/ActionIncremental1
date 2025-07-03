class_name CardModifier
extends Object


static func get_modified_card(card_state : CardState) -> CardState:
	var new_card_state = CardState.new_from_other_card_state(card_state)
	new_card_state.cost = _get_modified_card_cost(new_card_state)
	new_card_state.name = _get_modified_card_name(new_card_state)
	new_card_state.image = _get_modified_card_image(new_card_state)
	new_card_state.rarity = _get_modified_card_rarity(new_card_state)
	new_card_state.element = _get_modified_card_element(new_card_state)
	new_card_state.effects = _get_modified_card_effects(new_card_state)
	new_card_state.played = false																	 
	return new_card_state

static func _get_modified_card_name(card: CardState) -> String:
	return card.name

static func _get_modified_card_cost(card : CardState) -> int:
	var cost = card.cost
	if(StatusManager.has_status(Status.Type.REDUCE_NEXT_CARD_COST)):
		cost -= StatusManager.get_status_value(Status.Type.REDUCE_NEXT_CARD_COST)
	return max(0, cost) 

static func _get_modified_card_image(card: CardState) -> Texture2D:
	return card.image

static func _get_modified_card_rarity(card: CardState) -> Constants.Rarity:
	return card.rarity

static func _get_modified_card_element(card: CardState) -> Constants.Element:
	return card.element

static func _get_modified_card_effects(card: CardState) -> Array[CardEffect]:
	return card.effects