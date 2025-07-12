class_name CardEffectGainGemsCounter
extends CardEffect

@export var gem_tier : Constants.GemTier = Constants.GemTier.TIER1
@export var counter : Counter
var modifier:
	get:
		return StatusManager.get_status_value(Status.Type.GEM_ADD)

var gems_to_gain_modified:
	get: return counter.get_count() + modifier

func apply_effect() -> void:
	GameplayManager.gems_this_run[gem_tier] += gems_to_gain_modified
	GameplayManager.gems_updated.emit()

func _get_description() -> String:
	var suffix = ""
	if(modifier < 0) :
		suffix += Util.add_BBCode_color("-" + str(modifier), Color.RED)
	if(modifier > 0) :
		suffix = Util.add_BBCode_color("+" + str(modifier), Color.GREEN)
	return "Gain gems equal to %s%s" % [counter.description , suffix]
