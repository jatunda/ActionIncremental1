class_name CardOfferingManager
extends Node

@export var starting_common_cards : Array[Card]
var common_cards : Array[CardState] 
#var rare_cards: Array[CardState]
@export var end_wall_card : Card
@export var t0_wall_cards_1 : Array[Card]
@export var t0_wall_cards_2 : Array[Card]
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var wall_draft_count :int = 0


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

func get_artifact_draft(requested_draft_size:int) -> Array[CardState]:
	return get_draft(requested_draft_size)

func get_wall_draft(requested_draft_size:int, tier:Constants.WallTier) -> Array[CardState]:
	wall_draft_count += 1

	if requested_draft_size < 1:	
		return []

	if tier == Constants.WallTier.TIER_0:
		if wall_draft_count == 1:
			return _card_array_to_card_state_array(t0_wall_cards_1)
		elif wall_draft_count == 2:
			return _card_array_to_card_state_array(t0_wall_cards_2)
		else:
			return [CardState.new(end_wall_card)]

	return []



func get_draft(requested_draft_size:int) -> Array[CardState]:
	if requested_draft_size < 1:
		return []

	# logic for choosing if we doing common/rare/wall cards goes here (eventually)
	var card_pool : Array[CardState] = common_cards

	if requested_draft_size > card_pool.size():
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
	while(output.size() < requested_draft_size or while_counter > 30) :
		var chosenCardState : CardState = card_pool[rng.rand_weighted(cardWeights)]
		if output.find(chosenCardState) == -1:
			output.append(chosenCardState)
		while_counter += 1
	
	return output


func _card_array_to_card_state_array(cards : Array[Card]) -> Array[CardState]:
	var output : Array[CardState] = []
	for card : Card in cards:
		output.append(CardState.new(card))
	return output
