extends Node

signal loaded_upgrades

var upgrades : Dictionary[Upgrade.UBID, Upgrade] = {}

# use a breadth-first search to apply upgrades
func apply_upgrades() -> void:

	# using dictionary for quick lookup
	var applied : Dictionary[Upgrade.UBID,bool] = {Upgrade.UBID.NONE:true}
	var queue : Array[Upgrade] = []

	# add all root upgrades to the queue
	for upgrade:Upgrade in upgrades.values():
		if upgrade.parent_ubid == Upgrade.UBID.NONE and upgrade.level > 0:
			queue.append(upgrade)

	# while queue has stuff
	while queue.is_empty() == false:
		# get frontmost upgrade
		var current_upgrade : Upgrade = queue.pop_front()
		# if it has been applied, continue
		if applied.has(current_upgrade.ubid):
			continue
		# if all dependencies have been applied 
		# (current implementation only has single dependency)
		if applied.has(current_upgrade.parent_ubid):
			current_upgrade.apply_effect()
			applied[current_upgrade.ubid] = true
			# add children to queue
			for child_upgrade:Upgrade in current_upgrade.children_upgrades.values():
				if child_upgrade.level > 0:
					queue.append(child_upgrade)
		else: # not all dependencies have been applied
			# requeue at the end for later
			queue.append(current_upgrade)
		
func get_savable_upgrades() -> Dictionary[Upgrade.UBID, int]:
	var output : Dictionary[Upgrade.UBID, int] = {}
	for upgrade : Upgrade in upgrades.values():
		output[upgrade.ubid] = upgrade.level
	return output

func load_saved_upgrades(saved_upgrades:Dictionary[Upgrade.UBID, int]) -> void:
	
	print(upgrades)

	# go through all existing upgrades and set their level to the saved upgrade
	for upgrade:Upgrade in upgrades.values():
		if saved_upgrades.has(upgrade.ubid):
			upgrade.level = saved_upgrades[upgrade.ubid]
		else:
			upgrade.level = 0

	# possible issue: upgrades is not yet loaded and is empty... then the above algorithm wouldn't work...

	# refresh update buttons
	loaded_upgrades.emit()
