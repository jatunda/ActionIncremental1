class_name Status

enum Type {
	REDUCE_NEXT_CARD_COST,
	GEM_ADD,
	DRAFT_SIZE,
	GEMS_PER_TURN,
	MOTES,
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

enum ApplicationTiming {
	IMMEDIATE,
	NEXT_TURN,
}

enum TriggerTiming {
	END_OF_TURN,
	NONE,
}


static func type_to_string(p_type : Type) -> String:
	return Type.keys()[p_type]

var type : Type
var positivity : Positivity
var duration_type : DurationType
var counter_type : CounterType 
var application_timing: ApplicationTiming
var counter : int = 0
var trigger_timing : TriggerTiming = TriggerTiming.NONE
var debug_text : String :
	get:
		var output : String = type_to_string(type)
		if counter_type == CounterType.COUNTER:
			output += " " + str(counter) 
		return output

func _init(p_type : Type, p_positivity : Positivity, p_duration_type : DurationType, 
		p_counter_type : CounterType, p_application_timing,
		p_trigger_timing : TriggerTiming,
		p_counter : int = 0, ):
	self.type = p_type
	self.positivity = p_positivity
	self.duration_type = p_duration_type
	self.counter_type = p_counter_type
	self.application_timing = p_application_timing
	self.counter = p_counter
	self.trigger_timing = p_trigger_timing

func _to_string() -> String:
	if counter_type == CounterType.COUNTER:
		return "%s %s" % [type_to_string(type), counter]
	return type_to_string(type)
