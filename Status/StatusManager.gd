## Singleton class
extends Node

signal on_status_update(new_active_statuses : Array[Status])

var active_statuses : Array[Status] = []
var status_queue : Array[Status] = []

## applys the given status type, with counter if relevant
func apply_status(status_type : Status.Type, counter:int = 0, ) -> void:
	var status: Status = Status.new(status_type, counter)
	if status.application_timing == Status.ApplicationTiming.IMMEDIATE:
		_add_status(status_type, counter)
	elif status.application_timing == Status.ApplicationTiming.NEXT_TURN:
		_queue_status(status_type, counter)
	
func _queue_status(status_type: Status.Type, counter:int):
	var status : Status = Status.new(status_type, counter)
	status_queue.append(status)

func _add_status(status_type: Status.Type, counter:int) -> void:
	var existing_status : Status = _get_status(status_type)
	if existing_status != null: # status of this type already exists
		# depending on the type of status, add to it, or override the counter
		if existing_status.counter_type == Status.CounterType.COUNTER:
			existing_status.counter += counter
			if existing_status.counter == 0:
				active_statuses.erase(existing_status)
		else: # no counter
			# do nothing
			pass
	else: # no existing status of this type
		var status : Status = Status.new(status_type, counter)
		active_statuses.append(status)

	_cancel_opposites(status_type)
	
	on_status_update.emit(active_statuses)

func _cancel_opposites(status_type: Status.Type) -> void:
	var opposite_type : Status.Type = Status.get_opposite_type(status_type)
	
	# type has no opposite, don't do anything
	if opposite_type == Status.Type.NONE:
		return
	
	# only do canceling if we have both opposites active
	if not has_status(status_type) or not has_status(opposite_type):
		return

	# no counter statuses both get destroyed
	if get_status_value(status_type) == 0:
		remove_status(status_type)
		remove_status(opposite_type)
		return
	
	var status_1_count : int = get_status_value(status_type)
	var status_2_count : int = get_status_value(opposite_type)
	decrease_status(status_type, status_2_count)
	decrease_status(opposite_type, status_1_count)


func remove_status(status_type : Status.Type) -> void:
	var status : Status = _get_status(status_type)
	if status == null:
		return
	active_statuses.erase(status)
	on_status_update.emit(active_statuses)
	
func decrease_status(status_type: Status.Type, counter: int) -> void:
	var status : Status = _get_status(status_type)
	if status == null:
		return
	if status.counter_type == Status.CounterType.NO_COUNTER:
		return
	status.counter -= counter
	if status.counter <= 0:
		active_statuses.erase(status)
	on_status_update.emit(active_statuses)

## returns the status, or null if it is not active.
func _get_status(status_type : Status.Type) -> Status:
	var index = active_statuses.find_custom( func(x): return status_type == x.type )
	if index == -1:
		return null
	return active_statuses[index]

## returns the counter value of the status type.
## [br] returns 0 if the status is not active.
## [br] returns 0 if the status does not have a counter.
func get_status_value(status_type : Status.Type) -> int:
	var status = _get_status(status_type)
	if status == null or status.counter_type == Status.CounterType.NO_COUNTER:
		return 0
	return status.counter
	
## returns true if the status is active. returns false otherwise.
func has_status(status_type : Status.Type) -> bool:
	var status = _get_status(status_type)
	return status != null

func trigger_status_effects(trigger_timing: Status.TriggerTiming):
	# apply any end of turn effects
	for status in active_statuses:
		if status.trigger_timing == trigger_timing:
			_trigger_status_effect(status.type)

func tick_statuses() -> void:
	var statuses_to_remove : Array[Status] = []
	for status in active_statuses:
		if status.duration_type == Status.DurationType.ONE_TURN:
			statuses_to_remove.append(status)
		if status.duration_type == Status.DurationType.COUNT_DOWN:
			status.counter -= 1
			if status.counter <= 0:
				statuses_to_remove.append(status)
		# the only other type is infinite, so we don't count those down

	# remove expired statuses
	for status_to_remove in statuses_to_remove:
		active_statuses.erase(status_to_remove)

	# add queued statuses
	for status in status_queue:
		_add_status(status.type, status.counter)

	status_queue.clear()
	on_status_update.emit(active_statuses)

func clear_all_statuses() -> void:
	active_statuses = []
	on_status_update.emit(active_statuses)

func _trigger_status_effect(type: Status.Type) -> void:
	match type:
		Status.Type.GEMS_PER_TURN:
			print_debug("adding %s gems" % [get_status_value(Status.Type.GEMS_PER_TURN)])
			GameplayManager.gems_this_run[Constants.GemTier.TIER1] += get_status_value(Status.Type.GEMS_PER_TURN)
			GameplayManager.gems_updated.emit()
		Status.Type.INNUNDATE:
			var most_recent_card_played:CardState = GameplayManager.card_history[-1]
			var new_innundate_status_type = Status.Type.NONE
			match most_recent_card_played.element:
				Constants.Element.WATER:
					new_innundate_status_type = Status.Type.INNUNDATE_WATER
				Constants.Element.FIRE:
					new_innundate_status_type = Status.Type.INNUNDATE_FIRE
				Constants.Element.AIR:
					new_innundate_status_type = Status.Type.INNUNDATE_AIR
				Constants.Element.EARTH:
					new_innundate_status_type = Status.Type.INNUNDATE_EARTH
				Constants.Element.DARK:
					new_innundate_status_type = Status.Type.INNUNDATE_DARK
				Constants.Element.LIGHT:
					new_innundate_status_type = Status.Type.INNUNDATE_LIGHT
			var counter : int = get_status_value(Status.Type.INNUNDATE)
			StatusManager.apply_status(new_innundate_status_type, counter)
			StatusManager.remove_status(Status.Type.INNUNDATE)

func get_innundated_elements() -> Array[Constants.Element]:
	var output : Array[Constants.Element] = []
	if has_status(Status.Type.INNUNDATE_AIR):
		output.append(Constants.Element.AIR)
	if has_status(Status.Type.INNUNDATE_EARTH):
		output.append(Constants.Element.EARTH)
	if has_status(Status.Type.INNUNDATE_WATER):
		output.append(Constants.Element.WATER)
	if has_status(Status.Type.INNUNDATE_FIRE):
		output.append(Constants.Element.FIRE)
	if has_status(Status.Type.INNUNDATE_DARK):
		output.append(Constants.Element.DARK)
	if has_status(Status.Type.INNUNDATE_LIGHT):
		output.append(Constants.Element.LIGHT)
	return output
