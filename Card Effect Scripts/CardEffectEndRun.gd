class_name CardEffectEndRun
extends CardEffect

@export var end_run_reason : Constants.EndRunReason = Constants.EndRunReason.UNDEFINED

func apply_effect() -> void:
    GameplayManager.drafting_manager.end_run(end_run_reason)

func _get_description() -> String:
    return "Ends the run"