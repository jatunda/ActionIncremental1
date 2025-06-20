class_name CardEffectGainSkips
extends CardEffect

@export var skips_to_gain : int = 1

func apply_effect() -> void:
    GameplayManager.skips += skips_to_gain

func _get_description() -> String:
    return "Gain %s skips" % str(skips_to_gain)