class_name CardOfferingManager
extends Node

@export var starting_common_cards : Array[Card]
@export var backup_common_card: Card
@export var starting_rare_cards : Array[Card]
@export var backup_rare_card: Card
var common_cards : Array[CardState] 
var rare_cards: Array[CardState]

@export_group("Wall Cards")
@export var end_wall_card : Card
@export_subgroup("Tier 0")
@export var t0_wall_cards_1 : Array[Card]
@export var t0_wall_cards_2 : Array[Card]
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var wall_draft_count :int = 0
var rounds_since_last_rare : int = 0


func _ready() -> void:
	GameplayManager.card_offering_manager = self
	rng.seed = hash(Time.get_unix_time_from_system())
	pass

func get_altered_common_cards() -> Array[CardState]:
	return common_cards.filter(
			func(c): return c.occurance_rate < 0.9999 or c.occurance_rate > 1.0001)

func populate_starting_offerings() -> void:
	common_cards = []
	rare_cards = []
	rounds_since_last_rare = -3
	for card : Card in starting_common_cards:
		common_cards.append(CardState.new(card))
	for rare_card : Card in starting_rare_cards:
		rare_cards.append(CardState.new(rare_card))

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

func get_wall_draft(requested_draft_size:int, wall_tier:int) -> Array[CardState]:
	wall_draft_count += 1

	if requested_draft_size < 1:	
		requested_draft_size = 1

	# very ugly because godot does not allow nested collections.
	# if I could, I would have Dict[wall_tier:int, Array[Array[Card]]]
	# where each wall tier has an array of drafts, 
	# and each draft has an array of cards 
	if wall_tier == 0:
		if wall_draft_count == 1:
			return _card_array_to_card_state_array(t0_wall_cards_1)
		elif wall_draft_count == 2:
			return _card_array_to_card_state_array(t0_wall_cards_2)
		else:
			return [CardState.new(end_wall_card)]
	# TODO wall cards for t1 wall
	if wall_tier == 1:
		if wall_draft_count == 1:
			return _card_array_to_card_state_array(t0_wall_cards_1)
		elif wall_draft_count == 2:
			return _card_array_to_card_state_array(t0_wall_cards_2)
		else:
			return [CardState.new(end_wall_card)]

	return [] # should never reach here



func get_draft(requested_draft_size:int) -> Array[CardState]:

	# choose between common or rare cards
	var card_pool : Array[CardState] = common_cards
	var should_give_rares : bool = randf() < max(rounds_since_last_rare, 0) * 0.01
	should_give_rares = should_give_rares and UpgradeManager.has_bought_upgrade(Upgrade.UBID.UNLOCK_RARES)
	#print_debug("rare chance: %s" % [max(rounds_since_last_rare, 0) * 0.01])
	if should_give_rares:
		card_pool = rare_cards
		rounds_since_last_rare = -3

	if requested_draft_size < 1:
		if should_give_rares:
			return [CardState.new(backup_rare_card)]
		else:
			return [CardState.new(backup_common_card)]

	# innundation effects
	var innundated_elements : Array[Constants.Element] = StatusManager.get_innundated_elements()
	if innundated_elements.size() > 0:
		card_pool = card_pool.filter( func (cs:CardState): return cs.element in innundated_elements)
	var heavy_presence_active : bool = StatusManager.has_status(Status.Type.HEAVY_PRESENCE)
	var weightless_presence_active : bool = StatusManager.has_status(Status.Type.WEIGHTLESS_PRESENCE)
	if heavy_presence_active:
		card_pool = card_pool.filter( func (cs:CardState): return cs.cost >= 5)
	if weightless_presence_active:
		card_pool = card_pool.filter( func (cs:CardState): return cs.cost <= 1)

	rounds_since_last_rare += 1
	return _get_random_cards_from_pool(card_pool, requested_draft_size)


func _get_random_cards_from_pool(card_pool:Array[CardState], num_cards_requested:int) -> Array[CardState]:
	if num_cards_requested > card_pool.size():
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
	while(output.size() < num_cards_requested or while_counter > 30) :
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

## resets cards to their start-of-game state
func reset_cards() -> void:
	for card_state : CardState in common_cards:
		card_state.reset_card_state()
