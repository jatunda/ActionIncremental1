class_name ConditionalCompareCounters
extends Conditional

enum ComparisonMode {
	GREATER_THAN,
	LESS_THAN,
	EQUAL,
	NOT_EQUAL,
	GREATER_THAN_OR_EQUAL_TO,
	LESS_THAN_OR_EQUAL_TO,
}

@export var counter_a : Counter
@export var comparison_mode : ComparisonMode
@export var counter_b : Counter

## to be overridden by child classes
func is_satisfied() -> bool:
	match comparison_mode:
		ComparisonMode.GREATER_THAN:
			return counter_a.get_count() > counter_b.get_count()
		ComparisonMode.LESS_THAN:
			return counter_a.get_count() < counter_b.get_count()
		ComparisonMode.GREATER_THAN_OR_EQUAL_TO:
			return counter_a.get_count() >= counter_b.get_count()
		ComparisonMode.LESS_THAN_OR_EQUAL_TO:
			return counter_a.get_count() <= counter_b.get_count()
		ComparisonMode.EQUAL:
			return counter_a.get_count() == counter_b.get_count()
		ComparisonMode.NOT_EQUAL:
			return counter_a.get_count() != counter_b.get_count()
		_:
			pass
	return false

static func comparison_mode_to_string(p_comparison_mode: ComparisonMode) -> String:
	match p_comparison_mode:
		ComparisonMode.GREATER_THAN:
			return "greater than"
		ComparisonMode.LESS_THAN:
			return "less than"
		ComparisonMode.GREATER_THAN_OR_EQUAL_TO:
			return "at least"
		ComparisonMode.LESS_THAN_OR_EQUAL_TO:
			return "at most"
		ComparisonMode.EQUAL:
			return "is"
		ComparisonMode.NOT_EQUAL:
			return "is not"
		_:
			pass
	return ""

## to be overridden by child classes
## [br] format: "if {return value}, then..."
func _get_description() -> String:
	var comparison_string = ConditionalCompareCounters.comparison_mode_to_string(comparison_mode)
	return "%s is %s %s" % [counter_a.description, comparison_string, counter_b.description]

