class_name Deck
extends Node

@export var cards : Array[Card]
var cardWeights : Array[float]
var rng : RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	for card in cards:
		cardWeights.append(1.0);

func populate_deck() -> void:
	# do nothing for now... 
	# right now, we are using a pre-generated deck from the export variable
	print("populate_deck does nothing - deck uses export variable")

func get_cards(numCards:int) -> Array[Card]:
	if numCards < 1:
		return []

	if numCards > cards.size():
		return cards

	# weighted drop table, no repeats
	
	var output : Array[Card] = []
	while(output.size() < numCards) :
		var chosenCard = cards[rng.rand_weighted(cardWeights)]
		if output.find(chosenCard) == -1:
			output.append(chosenCard)
	
	return output
