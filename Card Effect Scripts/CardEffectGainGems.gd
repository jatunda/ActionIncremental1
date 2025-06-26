extends CardEffect

class_name CardEffectGainGems
@export var _gem_tier : Constants.GemTier = Constants.GemTier.TIER1
@export var _gemsToGain: int = 1 : 
	get:
		return _gemsToGain
	set(value): 
		_gemsToGain = max(0, value)

var gems_to_gain_modified : int :
	get:
		var output = _gemsToGain
		if StatusManager.has_status(Status.Type.GEM_ADD):
			output += StatusManager.get_status_value(Status.Type.GEM_ADD)
		return output

func apply_effect() -> void:
	GameplayManager.gems_this_run[_gem_tier] += gems_to_gain_modified
	GameplayManager.gems_updated.emit()

func _get_description() -> String:
	var number_string = str(_gemsToGain)
	if(_gemsToGain > gems_to_gain_modified) :
		number_string = Util.add_BBCode_color(str(gems_to_gain_modified), Color.RED)
	if(_gemsToGain < gems_to_gain_modified) :
		number_string = Util.add_BBCode_color(str(gems_to_gain_modified), Color.GREEN)
	var tier_string : String = Constants.gem_tier_to_string(_gem_tier)
	var gem_string = "Gem" if gems_to_gain_modified == 1 else "Gems"
	return "Gain %s %s %s" % [number_string, tier_string, gem_string]
