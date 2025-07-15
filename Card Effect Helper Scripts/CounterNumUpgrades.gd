class_name CounterNumUpgrades
extends Counter

func get_count() -> int:
	var output : int = 0
	for upgrade : Upgrade in UpgradeManager.upgrades.values():
		output += upgrade.level
	return output

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "total upgrade levels"

