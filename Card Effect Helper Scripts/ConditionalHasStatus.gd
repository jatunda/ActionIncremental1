class_name ConditionalHasStatus
extends Conditional

@export var statusType: Status.Type

## to be overridden by child classes
func is_satisfied() -> bool:
	return StatusManager.has_status(statusType)

## to be overridden by child classes
## [br] format: "if {return value}, then..."
func _get_description() -> String:
	return "%s is active" % [Status.type_to_string(statusType)]
