class_name CardEffectSetWallGem
extends CardEffect

@export var amount : int

func apply_effect() -> void:
	GameplayManager.gems_this_run[Constants.GemTier.WALL] = amount
	GameplayManager.gems_updated.emit()

func _get_description() -> String:
	return "Set WALL GEMS to %s" % amount