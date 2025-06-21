class_name CounterStatusValue
extends Counter

@export var status_type : Status.Type 

func get_count() -> int:
	return StatusManager.get_status_value(status_type)

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "%s" % [Status.type_to_string(status_type)]