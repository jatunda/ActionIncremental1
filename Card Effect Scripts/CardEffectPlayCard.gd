class_name CardEffectPlayCard
extends CardEffect

@export var card : Card
@export var should_randomize_element : bool

func apply_effect() -> void:
	var drafting_manager : DraftingManager = GameplayManager.drafting_manager
	if drafting_manager == null:
		return
	var card_to_play : Card = card.duplicate()
	if should_randomize_element:
		var random_element : Constants.Element = randi() % Constants.Element.size() as Constants.Element
		card_to_play.element = random_element
	drafting_manager.try_play_card(card_to_play)

func _get_description() -> String:
	# this method is to be overridden by subclasses
	var suffix : String = ""
	if should_randomize_element:
		suffix += " with a random element"
	return "Play a %s%s" % [card.name, suffix]
