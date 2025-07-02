class_name CardEffectPlayOtherCards
extends CardEffect

@export var should_play_with_zero_cost : bool = false
@export var card_name_that_this_effect_is_on : String

func apply_effect() -> void:

	var cards_to_play : Array[CardState] = GameplayManager.drafting_manager.get_current_offered_cards([card_name_that_this_effect_is_on])
		
	# if required, change cards to be 0 cost
	if should_play_with_zero_cost:
		for card in cards_to_play:
			card.cost = 0

	# play cards
	for card in cards_to_play:
		GameplayManager.drafting_manager.try_play_card(card)
	

func _get_description() -> String:
	# this method is to be overridden by subclasses
	var suffix : String = " you can afford"
	if should_play_with_zero_cost:
		suffix = " for free"
	return "Play all other cards%s" % [suffix]
