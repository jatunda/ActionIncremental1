class_name CardOfferingManager
extends Node

@export var starting_common_cards : Array[Card]
var common_cards : Array[CardState] 
#var rare_cards: Array[CardState]
#var wall_cards: Array[CardState]
var rng : RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	GameplayManager.card_offering_manager = self
	rng.seed = hash(Time.get_unix_time_from_system())
	pass

func get_altered_common_cards() -> Array[CardState]:
	return common_cards.filter(
			func(c): return c.occurance_rate < 0.9999 or c.occurance_rate > 1.0001)

func populate_starting_offerings() -> void:
	for card : Card in starting_common_cards:
		common_cards.append(CardState.new(card))

func add_common_offering(card:Card) -> void:
	common_cards.append(CardState.new(card))

# returns true if card was found and replaced. returns false if card was not found.
func replace_card(old_card:Card, new_card:Card) -> bool:
	# find card
	var i : int = common_cards.find_custom(func(c:CardState)->bool: return c.name == old_card.name)
	if i == -1:
		return false
	# replace card
	common_cards[i] = CardState.new(new_card)
	return true


func get_draft(draft_size:int) -> Array[CardState]:
	if draft_size < 1:
		return []

	# logic for choosing if we doing common/rare/wall cards goes here (eventually)
	var card_pool : Array[CardState] = common_cards

	if draft_size > card_pool.size():
		var small_offerings_output : Array[CardState] = []
		for cardState in card_pool:
			small_offerings_output.append(cardState)
		return small_offerings_output


	# weighted drop table, no repeats

	var cardWeights: Array[float] = []
	for card in card_pool:
		cardWeights.append(card.occurance_rate as float)

	var while_counter = 0
	var output : Array[CardState] = []
	while(output.size() < draft_size or while_counter > 30) :
		var chosenCardState : CardState = card_pool[rng.rand_weighted(cardWeights)]
		if output.find(chosenCardState) == -1:
			output.append(chosenCardState)
		while_counter += 1
	
	return output
