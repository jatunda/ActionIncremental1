class_name SaveFileDisplay
extends CenterContainer

@export var _file_number : int = 1

@export_group("internal references")
@export var info_label : Label
@export var start_game_button: Button
@export var delete_file_button : Button

func _ready() -> void:
	start_game_button.pressed.connect(_on_start_game_button_pressed)
	delete_file_button.pressed.connect(_on_delete_file_button_pressed)
	load_save_into_display()

func _on_start_game_button_pressed() -> void:
	GameplayManager.current_file_number = _file_number

	var save_file_info : SaveFileInfo = SaveLoadManager.get_save_file_info(_file_number)
	
	if not save_file_info:
		print_debug("starting new game. File number %s" % _file_number)
		SceneManager.go_to_drafting_scene()
		return

	# if we are here, we have a save
	print_debug("continuing game. File number %s" % _file_number)
	SaveLoadManager.load_save(_file_number)
	SceneManager.go_to_upgrades_scene()		

func _on_delete_file_button_pressed() -> void:
	SaveLoadManager.delete_save(_file_number)
	load_save_into_display()

	# future version:
		# show a "are you sure?" page
		# disable all other buttons in scene?
		# move delete functionality into the confirm button
	pass

# on "are you sure?" popup -> yes button
	# hide are you sure page
	# delete save
	# load_save()

# on "are you sure?" popup -> no button
	# hide are you sure page

func load_save_into_display() -> void:
	var save_file_info : SaveFileInfo = SaveLoadManager.get_save_file_info(_file_number)
	
	if not save_file_info:
		info_label.text = "Empty File"
		start_game_button.text = "Start New Game"
		delete_file_button.visible = false
		return
	
	# create display text
	var info_text = ""

	# gems
	info_text += "Gems: %s\n" % save_file_info.gems[Constants.GemTier.TIER1]

	# upgrades
	var num_upgrades = 0
	for i:int in save_file_info.upgrades.values():
		if i > 0:
			num_upgrades += 1
	info_text += "Upgrades Bought: %s\n" % num_upgrades

	# wall Tier
	var wall_tier = 0
	for ubid : Upgrade.UBID in save_file_info.upgrades.keys():
		if ubid == Upgrade.UBID.WALL_T0:
			if save_file_info.upgrades[ubid] > 0:
				wall_tier = max(1, wall_tier)
		elif ubid == Upgrade.UBID.WALL_T1:
			if save_file_info.upgrades[ubid] > 0:
				wall_tier = max(2, wall_tier)
	if wall_tier > 0:
		info_text += "Wall Tier: %s\n" % wall_tier
	
	info_label.text = info_text

	# update buttons
	start_game_button.text = "Continue Game"
	delete_file_button.visible = true
