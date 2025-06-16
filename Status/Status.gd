class_name Status

enum Type {
	REDUCE_NEXT_CARD_COST,
	GEM_ADD,
}

enum Positivity {
	POSTIVE,
	NEGATIVE,
	NEUTRAL,
}

enum DurationType {
	INFINITE,
	COUNT_DOWN,
	ONE_TURN,
}

enum CounterType {
	COUNTER,
	NO_COUNTER
}

enum PriorityBracket {
	START_OF_TURN,
	ADDITIVE,
	MULTIPLICATIVE,
	END_OF_TURN,
}

var type : Type
var positivity : Positivity
var priority : PriorityBracket
var duration_type : DurationType
var counter_type : CounterType 
var counter : int = 0
var debug_text : String :
	get:
		var output : String = Type.keys()[type]
		if counter_type == CounterType.COUNTER:
			output += " " + str(counter) 
		return output

func _init(p_type : Type, p_positivity : Positivity, p_priority : PriorityBracket,
		p_duration_type : DurationType, p_counter_type : CounterType, p_counter : int = 0):
	self.type = p_type
	self.positivity = p_positivity
	self.priority = p_priority
	self.duration_type = p_duration_type
	self.counter_type = p_counter_type
	self.counter = p_counter

func _to_string() -> String:
	if counter_type == CounterType.COUNTER:
		return "%s %s" % [Type.keys()[type], counter]
	return Type.keys()[type]