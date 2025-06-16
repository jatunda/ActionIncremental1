class_name Counter
extends Resource

var description : String :
	get:
		return _get_description()

## to be overridden by child classes
func get_count() -> int:
	return 0

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "counter that can't count (use child classes)"



