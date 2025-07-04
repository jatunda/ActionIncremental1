class_name CardEffectEndRun
extends CardEffect

func apply_effect() -> void:
    GameplayManager.time_left = -1000000

func _get_description() -> String:
    return "Ends the run"