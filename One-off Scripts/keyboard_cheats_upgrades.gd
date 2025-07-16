extends Node


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
			GameplayManager.gems_total[Constants.GemTier.TIER1] += 100
			GameplayManager.gems_updated.emit()
			print_debug("Cheat: +100 gems")
		KEY_X:
			GameplayManager.gems_total[Constants.GemTier.WALL] = 1
			GameplayManager.gems_updated.emit()
			print_debug("Cheat: Wall Gems set to 1")
		KEY_Q: 
			SaveLoadManager.save(GameplayManager.current_file_number)
		KEY_W:
			SaveLoadManager.load_save(GameplayManager.current_file_number)

		
