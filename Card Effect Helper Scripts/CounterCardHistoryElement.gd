class_name CounterCardHistoryElement
extends Counter

@export var element : Constants.Element

## to be overridden by child classes
func get_count() -> int:
	return GameplayManager.card_history.filter(
				func(x:Card): return x.element==element
			).size()
	

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	var element_string : String = Constants.Element.keys()[element]
	return "%s runes you have" % [element_string]
