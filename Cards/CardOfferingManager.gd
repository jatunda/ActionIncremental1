class_name CardOfferingManager
extends Node

class CardState :
	var _original_card : Card
	var occurance_rate : float
	var card : Card

	func _init(p_original_card : Card, p_occurance_rate : float = 1.0) -> void:
		_original_card = p_original_card.duplicate()
		occurance_rate = p_occurance_rate
		card = _original_card.duplicate()

@export var _cards_unaltered : Array[Card]
var common_cards : Array[CardState]
var rare_cards: Array[CardState]
var wall_cards: Array[CardState]
var rng : RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	pass

func get_altered_common_cards() -> Array[CardState]:
	return common_cards.filter(
			func(c): return c.occurance_rate < 0.9999 or c.occurance_rate > 1.0001)

func populate_offerings() -> void:
	for card_unaltered : Card in _cards_unaltered:
		var card_state : CardState = CardState.new(card_unaltered)		
		if card_state.card.rarity == Constants.Rarity.RARE:
			rare_cards.append(card_state)
		elif card_state.card.rarity == Constants.Rarity.WALL:
			pass # to be implemented once the upgrade screen exists
		else: # common and uncommon rarities
			common_cards.append(card_state)

func get_cards(numCards:int) -> Array[Card]:
	if numCards < 1:
		return []

	# logic for choosing if we doing common/rare/wall cards goes here (eventually)
	var card_pool : Array[CardState] = common_cards

	if numCards > card_pool.size():
		var small_offerings_output : Array[Card] = []
		for cardState in card_pool:
			small_offerings_output.append(cardState.card)
		return small_offerings_output


	# weighted drop table, no repeats

	var cardWeights: Array[float] = []
	for card in card_pool:
		cardWeights.append(card.occurance_rate as float)

	var while_counter = 0
	var output : Array[Card] = []
	while(output.size() < numCards or while_counter > 30) :
		var chosenCard : Card = card_pool[rng.rand_weighted(cardWeights)].card
		if output.find(chosenCard) == -1:
			output.append(chosenCard)
		while_counter += 1
	
	return output
