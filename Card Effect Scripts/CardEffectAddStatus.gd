class_name CardEffectAddStatus
extends CardEffect

@export var statusType: Status.Type

## Optional. Does not apply to all status types.
@export var counter : int = 0 

## adds the specified status type
func apply_effect() -> void:
	StatusManager.apply_status(statusType, counter)

func _get_description() -> String:
	var counter_text = str(counter) + " " if counter != 0  else ""
	return "Gain " + counter_text + Status.type_to_string(statusType) 
