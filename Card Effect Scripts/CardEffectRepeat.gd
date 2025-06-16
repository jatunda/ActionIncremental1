class_name CardEffectRepeat
extends CardEffect

## repeats the effects multiple times based on the counter

@export var counter : Counter
@export var effects : Array[CardEffect]

## To be overridden by specific effect implementations.
func apply_effect() -> void:
	var repeat_times = counter.get_count()
	for i in range(repeat_times):
		for effect in effects:
			effect.apply_effect()

func _get_description() -> String:
	# this method is to be overridden by subclasses
	var effects_string : String = ""
	var is_first : bool = true
	for effect in effects:
		if is_first:
			is_first = false
		else:
			effects_string += " and "
		effects_string += effect.description
	return "for each %s, %s" % [counter.description, effects_string]
