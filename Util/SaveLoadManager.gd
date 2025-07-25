extends Node

func get_file_path(file_number:int) -> String:
	return "user://RuneWeaverSaveGame%s.save" % str(file_number)

func delete_save(file_number:int) -> void:
	var file_path = get_file_path(file_number)
	if FileAccess.file_exists(file_path):
		var dir = DirAccess.open("user://")
		if dir:
			var err = dir.remove(file_path)
			if err == OK:
				print("Save file deleted successfully.")
			else:
				print("Error deleting save file: ", err)
		else:
			print("Could not open directory.")
	else:
		print("Save file does not exist.")

func save(file_number:int) -> void:

	# fill in our save dictionary
	var save_dict : Dictionary[String,Variant] = {
		"gems" : GameplayManager.gems_total,
		"upgrades": UpgradeManager.get_savable_upgrades(),
	}

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_dict, "\t")

	# Store the save dictionary as a new line in the save file.
	var save_file = FileAccess.open(get_file_path(file_number), FileAccess.WRITE)
	save_file.store_line(json_string)

## returns true if load successful, false otherwise
func load_save(file_number:int) -> bool:	
	var save_file_info : SaveFileInfo = get_save_file_info(file_number)

	if not save_file_info:
		return false

	# load gems
	if save_file_info.gems:
		GameplayManager.gems_total = save_file_info.gems.duplicate(true)
		GameplayManager.gems_updated.emit()

	# load upgrades
	if save_file_info.upgrades:
		UpgradeManager.load_saved_upgrades(save_file_info.upgrades)

	return true

## returns null if file not found
func get_save_file_info(file_number:int) -> SaveFileInfo:
	var file_path = get_file_path(file_number)
	if not FileAccess.file_exists(file_path):
		return null # Error! We don't have a save to load.

	var save_file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if not parse_result == OK:
		print_debug("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null

	# load gems
	var gems : Dictionary[Constants.GemTier, int] = {}
	for key in json.data["gems"].keys():
		var gem_tier : Constants.GemTier = int(key) as Constants.GemTier
		gems[gem_tier] = int(json.data["gems"][key])

	# load upgrades
	var upgrades : Dictionary[Upgrade.UBID, int] = {}
	for key in json.data["upgrades"].keys():
		var ubid : Upgrade.UBID = int(key) as Upgrade.UBID
		upgrades[ubid] = int(json.data["upgrades"][key])

	var save_file_info : SaveFileInfo = SaveFileInfo.new(gems, upgrades)
	return save_file_info
