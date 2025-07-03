class_name CounterGemsThisRound
extends Counter

func get_count() -> int:
	return GameplayManager.gems_this_run[Constants.GemTier.TIER1]

## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "gems"