extends Node2D


func _input(event: InputEvent) -> void:
	if not(event is InputEventKey):
		return
	
	var inputEventKey : InputEventKey = event as InputEventKey

	if inputEventKey.pressed == false:
		return

	match inputEventKey.keycode:
		KEY_G:
			GameplayManager.gems_this_run[Constants.GemTier.TIER1] += 100
			GameplayManager.gems_updated.emit()
			print_debug("Cheat: Gained 100 gems, +5 gems per turn")
		KEY_C:
			GameplayManager.capacity_left += 100
			print_debug("Cheat: gain 100 capacity")
		KEY_D:
			GameplayManager.time_left += 100
			print_debug("Cheat: gain 100 time")
		KEY_S:
			var status_type : Status.Type = Status.Type.MOTES
			StatusManager.apply_status(status_type, 10)
			print_debug("Cheat: gain status %s" % Status.type_to_string(status_type))
		KEY_Q:
			var status_type : Status.Type = Status.Type.MOTES
			StatusManager.apply_status(status_type, -1)
			print_debug("Cheat: decrease status %s" % Status.type_to_string(status_type))
		
