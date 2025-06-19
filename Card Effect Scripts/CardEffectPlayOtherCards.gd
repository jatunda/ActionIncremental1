class_name CardEffectPlayOtherCards
extends CardEffect

@export var should_play_with_zero_cost : bool = false
@export var card_name_that_this_effect_is_on : String

func apply_effect() -> void:

	# get all cards
	var all_cards : Array[Card] = GameplayManager.drafting_manager.current_offered_cards
	# remove me from list of cards
	var cards_to_play : Array[Card] = []
	for card in all_cards:
		if card.name == card_name_that_this_effect_is_on:
			pass
		else:
			cards_to_play.append(card.duplicate())
		
	# if required, make copies of all cards where they are 0 cost
	if(should_play_with_zero_cost):
		var original_cards_to_play = cards_to_play
		cards_to_play = []
		for card in original_cards_to_play:
			var zero_cost_card : Card = card.duplicate()
			zero_cost_card.cost = 0
			cards_to_play.append(zero_cost_card)

	# prevent recursion
	for card in cards_to_play:
		if card.has_effect(CardEffectPlayOtherCards):
			card.remove_effects_of_type(CardEffectPlayOtherCards)

	# play cards
	for card in cards_to_play:
		GameplayManager.drafting_manager.try_play_card(card)
	pass

func _get_description() -> String:
	# this method is to be overridden by subclasses
	var suffix : String = " you can afford"
	if should_play_with_zero_cost:
		suffix = " for free"
	return "Play all other cards%s" % [suffix]
