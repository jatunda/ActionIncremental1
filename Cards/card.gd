class_name Card
extends Resource

@export var name: String
@export var cost: int
@export var image: Texture2D
@export var rarity: Constants.Rarity = Constants.Rarity.COMMON
@export var element: Constants.Element
@export var effects: Array[CardEffect] = []
#@export var flavor_text: String = ""

var description: String :
    get:
        return get_description()

func applyEffects() -> void:
    for effect in effects: 
        effect.apply_effect()

func _to_string():
    return name

func get_description() -> String:
    if effects.size() < 1:
        return "no effect"
    
    var output : String = ""
    var is_first_effect : bool = true
    for effect in effects: 
        if is_first_effect:
            is_first_effect = false
        else:
            output += ", "
        output += effect.description

    return output