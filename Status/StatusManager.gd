extends Node

signal on_status_update(new_active_statuses : Array[Status])

var active_statuses : Array[Status] = []
var status_queue : Array[Status] = []

## adds a status to the queue, to start taking effect at the start of next turn.
## If you your status has a countdown, or is a single-turn status, use this.
## [br]If you want your status to take effect immediately, before the end of the turn, 
## use [add_status] instead
func queue_status(status_type: Status.Type, counter:int = 0):
	var status : Status = _generate_status(status_type, counter)
	status_queue.append(status)

## Add a status to the list of current active statuses. 
## If this status already exists, it will increase the counter of the status by the given amount.
## [br]Use this funtion if you want your status to take effect immediately 
## (and therefore count down immediately). If you are creating a status that expires based on turns,
## you should probably use [queue_status] instead
func _add_status(status_type: Status.Type, counter:int = 0) -> void:
	var existing_status : Status = _get_status(status_type)
	if existing_status != null: # status of this type already exists
		# depending on the type of status, add to it, or override the counter
		if existing_status.counter_type == Status.CounterType.COUNTER:
			existing_status.counter += counter
		else: # no counter
			# do nothing
			pass
	else: # no existing status of this type
		var status : Status = _generate_status(status_type, counter)
		active_statuses.append(status)
	on_status_update.emit(active_statuses)

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
	status.counter -= counter
	on_status_update.emit(active_statuses)

## returns the status, or null if it is not active.
func _get_status(status_type : Status.Type) -> Status:
	var index = active_statuses.find_custom( func(x): return status_type == x.type )
	if index == -1:
		return null
	return active_statuses[index]

## returns the counter value of the status type.
## [br]returns -1 if the status is not active.
## [br] returns 0 if the status does not have a counter.
func get_status_value(status_type : Status.Type) -> int:
	var status = _get_status(status_type)
	if status == null or status.counter_type == Status.CounterType.NO_COUNTER:
		return -1
	return status.counter
	
## returns true if the status is active. returns false otherwise.
func has_status(status_type : Status.Type) -> int:
	var status = _get_status(status_type)
	return status != null

static func _generate_status(status_type : Status.Type, counter : int = 0) -> Status:
	match status_type:
		Status.Type.REDUCE_NEXT_CARD_COST:
			return Status.new(Status.Type.REDUCE_NEXT_CARD_COST,
					Status.Positivity.POSTIVE,
					Status.PriorityBracket.ADDITIVE,
					Status.DurationType.ONE_TURN,
					Status.CounterType.COUNTER,
					counter)
		Status.Type.GEM_ADD:
			return Status.new(Status.Type.GEM_ADD,
					Status.Positivity.POSTIVE,
					Status.PriorityBracket.ADDITIVE,
					Status.DurationType.INFINITE,
					Status.CounterType.COUNTER,
					counter)
		_:
			return null

func tick_statuses() -> void:
	var statuses_to_remove : Array[Status] = []
	for status in active_statuses:
		if status.duration_type == Status.DurationType.ONE_TURN:
			statuses_to_remove.append(status)
		if status.duration_type == Status.DurationType.COUNT_DOWN:
			status.counter -= 1
			if status.counter < 0:
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
