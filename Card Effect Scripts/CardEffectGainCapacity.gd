class_name CardEffectGainCapacity
extends CardEffect

## takes precedence over const_value if this exists
@export var counter : Counter = null
@export var const_value: int = 0

var capacity_to_gain_modified:
	get:
		if counter:
			return counter.get_count()
		return const_value

func apply_effect() -> void:
	GameplayManager.capacity_left += capacity_to_gain_modified
	pass

func _get_description() -> String:
	if counter:
		return "gain capacity equal to %s" % [counter.description]
	# this method is to be overridden by subclasses
	return "gain %s capacity" % [capacity_to_gain_modified] 

