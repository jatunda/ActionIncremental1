class_name Conditional
extends Resource

var description : String :
	get:
		return _get_description()

## to be overridden by child classes
func is_satisfied() -> bool:
	return false

## to be overridden by child classes
## [br] format: "if {return value}, then..."
func _get_description() -> String:
	return "you don't use the base conditional class"