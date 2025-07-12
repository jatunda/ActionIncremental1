class_name Status

enum Type {
	REDUCE_NEXT_CARD_COST,
	GEM_ADD,
	DRAFT_SIZE,
	GEMS_PER_TURN,
	MOTES,
	NONE,
	INNUNDATE,
	INNUNDATE_WATER,
	INNUNDATE_FIRE,
	INNUNDATE_AIR,
	INNUNDATE_EARTH,
	INNUNDATE_LIGHT,
	INNUNDATE_DARK,
	WEIGHTLESS_PRESENCE,
	HEAVY_PRESENCE,
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
	START_OF_TURN,
	CARD_PLAYED,
}


static func type_to_string(p_type : Type) -> String:
	return Type.keys()[p_type]

static func get_opposite_type(p_type: Type) -> Type:
	match p_type:
		Type.HEAVY_PRESENCE:
			return Type.WEIGHTLESS_PRESENCE
		Type.WEIGHTLESS_PRESENCE:
			return Type.HEAVY_PRESENCE
		_:
			return Type.NONE

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

func _init(p_status_type : Status.Type, p_counter : int = 0):
	self.type = p_status_type
	self.counter = p_counter
	match p_status_type:
		Status.Type.REDUCE_NEXT_CARD_COST:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.ONE_TURN
			self.counter_type = Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.NEXT_TURN
			self.trigger_timing = Status.TriggerTiming.NONE
		Status.Type.GEM_ADD:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.INFINITE
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.IMMEDIATE
			self.trigger_timing = Status.TriggerTiming.NONE
		Status.Type.DRAFT_SIZE:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.INFINITE
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.IMMEDIATE
			self.trigger_timing = Status.TriggerTiming.NONE
		Status.Type.GEMS_PER_TURN:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.COUNT_DOWN
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.IMMEDIATE
			self.trigger_timing = Status.TriggerTiming.END_OF_TURN
		Status.Type.MOTES:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.INFINITE
			self.counter_type = Status.CounterType.COUNTER
			self.application_timing =	Status.ApplicationTiming.IMMEDIATE
			self.trigger_timing = Status.TriggerTiming.NONE
		Status.Type.INNUNDATE:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.INFINITE
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.NEXT_TURN
			self.trigger_timing = Status.TriggerTiming.CARD_PLAYED
		Status.Type.INNUNDATE_WATER, Status.Type.INNUNDATE_AIR, Status.Type.INNUNDATE_FIRE, Status.Type.INNUNDATE_EARTH, Status.Type.INNUNDATE_LIGHT, Status.Type.INNUNDATE_DARK:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.COUNT_DOWN
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.NEXT_TURN
			self.trigger_timing = Status.TriggerTiming.NONE
		Status.Type.WEIGHTLESS_PRESENCE, Status.Type.HEAVY_PRESENCE:
			self.positivity = Status.Positivity.POSTIVE
			self.duration_type = Status.DurationType.COUNT_DOWN
			self.counter_type =	Status.CounterType.COUNTER
			self.application_timing = Status.ApplicationTiming.NEXT_TURN
			self.trigger_timing = Status.TriggerTiming.NONE
	pass

func _to_string() -> String:
	if counter_type == CounterType.COUNTER:
		return "%s %s" % [type_to_string(type), counter]
	return type_to_string(type)
