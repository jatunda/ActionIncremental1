class_name SaveFileInfo
extends Object


var gems : Dictionary[Constants.GemTier, int]
var upgrades : Dictionary[Upgrade.UBID, int]

func _init(
		p_gems : Dictionary[Constants.GemTier, int], 
		p_upgrades : Dictionary[Upgrade.UBID, int]):

	gems= p_gems.duplicate(true)
	upgrades = p_upgrades.duplicate(true)