extends Node2D


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if not(event is InputEventKey):
		return
	
	var inputEventKey : InputEventKey = event as InputEventKey

	if inputEventKey.pressed == false:
		return

	match inputEventKey.keycode:

		KEY_C:
			if GameplayManager.drafting_manager._run_summary.visible:
				GameplayManager.gems_this_run[Constants.GemTier.TIER1] += 100
				GameplayManager.gems_total[Constants.GemTier.TIER1] += 100
				GameplayManager.gems_updated.emit()
				print_debug("Cheat: +100 gems")
			else:
				GameplayManager.capacity_left += 100			
				GameplayManager.time_left += 100
				GameplayManager.gems_this_run[Constants.GemTier.TIER1] += 100
				GameplayManager.gems_updated.emit()
				print_debug("Cheat: gain 100 capacity, time, gems")

		KEY_X:
			var status_type : Status.Type = Status.Type.MOTES
			StatusManager.apply_status(status_type, 10)
			print_debug("Cheat: gain status %s" % Status.type_to_string(status_type))
		KEY_Z:
			var status_type : Status.Type = Status.Type.MOTES
			StatusManager.apply_status(status_type, -1)
			print_debug("Cheat: decrease status %s" % Status.type_to_string(status_type))
		
