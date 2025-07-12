class_name CounterGemsGained
extends Counter

## takes precedence over the other CardEffect
@export var card_effect_gain_gems : CardEffectGainGems = null
@export var card_effect_gain_gems_counter : CardEffectGainGemsCounter = null

func get_count() -> int:
	if card_effect_gain_gems:
		return card_effect_gain_gems.gems_to_gain_modified
	if card_effect_gain_gems_counter:
		return card_effect_gain_gems_counter.gems_to_gain_modified
	return 0
 
## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "gems gained by this card"
