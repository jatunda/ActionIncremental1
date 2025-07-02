extends Node

## unique button ID


var upgrades : Dictionary[Upgrade.UBID, Upgrade] = {}


func apply_upgrades() -> void:
	print_debug("applying all upgrades")
	
	# loop through upgrades, applying the ones we can. 
	# some upgrades have dependencies, so we should keep trying until 
	# we finish them all, or no more apply. 
	# TODO: apply upgrades using a bfs instead of this repeat loop structure?
	var upgrades_to_apply : Array[Upgrade] = upgrades.values()
	while true: #gdscript version of a do while
		var upgrades_that_failed_to_apply : Array[Upgrade] = []
		for upgrade_to_apply in upgrades_to_apply:
			var was_effect_applied = upgrade_to_apply.apply_effect()
			if not was_effect_applied:
				upgrades_that_failed_to_apply.append(upgrade_to_apply)
		
		if upgrades_that_failed_to_apply.size() == 0:
			# finished applying
			break;
		if upgrades_that_failed_to_apply.size() == upgrades_to_apply.size():
			# we couldn't apply any upgrades this round
			break
		
		# Keep reiterating on the upgrades list until it does not shrink
		upgrades_to_apply = upgrades_that_failed_to_apply
