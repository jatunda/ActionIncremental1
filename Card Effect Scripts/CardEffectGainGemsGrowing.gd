class_name CardEffectGainGemsGrowing
extends CardEffect

@export var starting_gems : int
@export var growth_rate : int

var ticks : int = 0
var gems_to_gain_modified:
	get:
		var modifier = StatusManager.get_status_value(Status.Type.GEM_ADD)
		return starting_gems + growth_rate * ticks + modifier

func apply_effect() -> void:
	GameplayManager.gems_this_run[Constants.GemTier.TIER1] += gems_to_gain_modified
	ticks += 1

func _get_description() -> String:
	return "gain %s gems. Increase the effect of this card by %s gems" % [gems_to_gain_modified, growth_rate]

func reset_effect() -> void:
	ticks = 0
	pass