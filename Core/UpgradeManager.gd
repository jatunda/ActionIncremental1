## Singleton
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

## only works during actual gameplay, once upgrades have been loaded already
func load_saved_upgrades(saved_upgrades:Dictionary[Upgrade.UBID, int]) -> void:

	# used to load upgrades before upgrades are initialized
	GameplayManager.saved_upgrade_levels = saved_upgrades

	# go through all existing upgrades and set their level to the saved upgrade
	# this is only for overriding upgrade levels once upgrades are initialized
	for upgrade:Upgrade in upgrades.values():
		if saved_upgrades.has(upgrade.ubid):
			upgrade.level = saved_upgrades[upgrade.ubid]
		else:
			upgrade.level = 0

	# refresh update buttons
	loaded_upgrades.emit()

## returns true if the upgrade has at least 1 level
func has_bought_upgrade(ubid: Upgrade.UBID) -> bool:
	return get_upgrade_level(ubid) > 0

## returns level of upgrade. returns -1 if upgrade is not found.
func get_upgrade_level(ubid : Upgrade.UBID) -> int:
	if not (ubid in upgrades):
		return -1
	return upgrades[ubid].level