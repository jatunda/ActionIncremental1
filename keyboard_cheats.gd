extends Node2D


func _input(event: InputEvent) -> void:
	if not(event is InputEventKey):
		return
	
	var inputEventKey : InputEventKey = event as InputEventKey

	if inputEventKey.pressed == false:
		return

	match inputEventKey.keycode:
		KEY_G:
			GameplayManager.gems += 100
			print("Cheat: Gained 100 gems, +5 gems per turn")
		KEY_C:
			GameplayManager.capacity_left += 100
			print("Cheat: gain 100 capacity")
		KEY_D:
			GameplayManager.draws_left += 100
			print("Cheat: gain 100 draws")
		KEY_S:
			var status_type : Status.Type = Status.Type.GEMS_PER_TURN
			StatusManager.apply_status(status_type, 10)
			print("Cheat: gain status %s" % Status.type_to_string(status_type))
