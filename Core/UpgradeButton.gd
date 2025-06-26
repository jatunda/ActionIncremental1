extends TextureButton

@export var upgrade_type : Constants.UpgradeType
@export var cost_gem_type : Constants.GemTier
@export var cost_per_level : Array[int] = [1]

@export var _label : Label

var level = 0

func _ready() -> void:
	pressed.connect(_on_pressed)
	if GameplayManager.upgrades.has(upgrade_type):
		level = GameplayManager.upgrades[upgrade_type]
	_update_text()

func _on_pressed() -> void:
	# if can't press
	if level >= cost_per_level.size():
		print("can't buy maxed upgrade: %s" % Constants.upgrade_type_to_string(upgrade_type))
		return
	if GameplayManager.gems < cost_per_level[level]:
		print("can't afford %s" % Constants.upgrade_type_to_string(upgrade_type))
		return

	# if we here, we can press

	# subtract cost
	GameplayManager.gems -= cost_per_level[level]
	# add upgrade
	level += 1
	_update_text()
	GameplayManager.upgrades[upgrade_type] = level

func _update_text() -> void:
	_label.text = "%s/%s" % [level, cost_per_level.size()]
