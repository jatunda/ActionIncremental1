class_name CounterConstant
extends Counter

@export var number : int

## to be overridden by child classes
func get_count() -> int:
	return number

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return str(number)
