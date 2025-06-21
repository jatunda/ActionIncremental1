class_name CardEffectGainGemsCounter
extends CardEffect

@export var counter : Counter
var modifier:
	get:
		return StatusManager.get_status_value(Status.Type.GEM_ADD)

func apply_effect() -> void:
	GameplayManager.gems += counter.get_count() + modifier

func _get_description() -> String:
	var suffix = ""
	if(modifier < 0) :
		suffix += Util.add_BBCode_color("-" + str(modifier), Color.RED)
	if(modifier > 0) :
		suffix = Util.add_BBCode_color("+" + str(modifier), Color.GREEN)
	return "Gain gems equal to %s%s" % [counter.description , suffix]