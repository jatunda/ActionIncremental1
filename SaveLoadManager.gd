extends Node

var _file_number : int = 1
var file_path: String : 
	get:
		return "user://RuneWeaverSaveGame%s.save" % str(_file_number)

func set_file_number(num : int) -> void:
	_file_number = clampi(num, 1, 3)

func save() -> void:

	# fill in our save dictionary
	var save_dict : Dictionary[String,Variant] = {
		"gems" : GameplayManager.gems_total,
		"upgrades": UpgradeManager.get_savable_upgrades(),
	}

	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_dict, "\t")

	# Store the save dictionary as a new line in the save file.
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	save_file.store_line(json_string)

## returns true if load successful, false otherwise
func load() -> bool:	
	if not FileAccess.file_exists(file_path):
		return false # Error! We don't have a save to load.

	var save_file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if not parse_result == OK:
		print_debug("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return false

	# load gems
	GameplayManager.gems_total = {}
	for key in json.data["gems"].keys():
		var gem_tier : Constants.GemTier = int(key) as Constants.GemTier
		GameplayManager.gems_total[gem_tier] = int(json.data["gems"][key])
	GameplayManager.gems_updated.emit()

	# load upgrades
	var saved_upgrades : Dictionary[Upgrade.UBID, int] = {}
	for key in json.data["upgrades"].keys():
		var ubid : Upgrade.UBID = int(key) as Upgrade.UBID
		saved_upgrades[ubid] = int(json.data["upgrades"][key])
	UpgradeManager.load_saved_upgrades(saved_upgrades)

	return true
