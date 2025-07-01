extends RichTextLabel

func _ready() -> void:

	# connect to signal from gameplay manager
	GameplayManager.gems_updated.connect(_on_gems_changed)
	_on_gems_changed()

func _on_gems_changed() -> void:
	# update the label text to show the current number of gems
	var output = ""
	for gem_tier in Constants.GemTier.values():
		if GameplayManager.gems_total.has(gem_tier):
			output += "%s Gems: %s" % [
					Constants.gem_tier_to_string(gem_tier),  
					str(GameplayManager.gems_total[gem_tier])]
	text = output
