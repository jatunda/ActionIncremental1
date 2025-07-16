class_name Card
extends Resource

@export var name: String
@export var cost: int
@export var image: Texture2D
@export var rarity: Constants.Rarity = Constants.Rarity.COMMON
@export var element: Constants.Element
@export var play_condition : Conditional = null
@export var effects: Array[CardEffect] = []
#@export var flavor_text: String = ""

func reset_card() -> void:
	for effect : CardEffect in effects:
		effect.reset_effect()