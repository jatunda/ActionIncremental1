class_name CardState
extends Object

## the template cared this instance is based on. DO NOT MODIFY
var __original_card : Card

var original_name : String : 
	get : return __original_card.name
var original_cost : int : 
	get : return __original_card.cost
var original_image : Texture2D : 
	get : return __original_card.image
var original_rarity : Constants.Rarity : 
	get : return __original_card.rarity
var original_element : Constants.Element : 
	get : return __original_card.element


var name : String
var cost : int 
var image : Texture2D 
var rarity : Constants.Rarity 
var element: Constants.Element 

## currently does not support editing
var play_condition : Conditional :
	get: return __original_card.play_condition

## currently does not support editing
var effects: Array[CardEffect] :
	get: return __original_card.effects

var occurance_rate : float
var played = false


func _init(p_original_card : Card, p_occurance_rate : float = 1.0) -> void:
	__original_card = p_original_card
	occurance_rate = p_occurance_rate
	name = __original_card.name
	cost = __original_card.cost
	image = __original_card.image
	rarity = __original_card.rarity
	element = __original_card.element

static func new_from_other_card_state(other:CardState) -> CardState:
	return CardState.new(other.__original_card, other.occurance_rate)

var description: String :
	get:
		return get_description()

func applyEffects() -> void:
	for effect in effects: 
		effect.apply_effect()

func _to_string():
	return name

func get_description() -> String:

	
	var output : String = ""

	if play_condition != null:
		output += "To play, must %s. " % play_condition.description

	if effects.size() < 1:
		output += "no effect."

	var is_first_effect : bool = true
	for effect in effects: 
		if is_first_effect:
			is_first_effect = false
		else:
			output += ", "
		output += effect.description

	return output + "."

func get_effects(p_class) -> Array[CardEffect]:
	var output : Array[CardEffect] = []
	for effect in effects:
		if is_instance_of(effect, p_class):
			output.append(effect)
	return output

func has_effect(p_class) -> bool:
	return get_effects(p_class).size() > 0

func remove_effects_of_type(p_class) -> void:
	for effect in effects:
		if is_instance_of(effect, p_class):
			effects.erase(effect)
