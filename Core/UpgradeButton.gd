@tool
class_name UpgradeButton
extends TextureButton

@export var upgrade_type : Constants.UpgradeType
@export var cost_gem_type : Constants.GemTier
@export var cost_per_level : Array[int] = [1]

@export var _label : Label
@export var _line : Line2D

var level = 0

func _ready() -> void:
	pressed.connect(_on_pressed)
	if GameplayManager.upgrades.has(upgrade_type):
		level = GameplayManager.upgrades[upgrade_type]
	_update_text()

	# draw line to parent
	_update_line()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): # only in editor
		_update_line()

func _on_pressed() -> void:
	if Engine.is_editor_hint(): return
	# if can't press
	if level >= cost_per_level.size():
		print_debug("can't buy maxed upgrade: %s" % Constants.upgrade_type_to_string(upgrade_type))
		return
	if GameplayManager.gems_total[Constants.GemTier.TIER1] < cost_per_level[level]:
		print_debug("can't afford %s" % Constants.upgrade_type_to_string(upgrade_type))
		return

	# if we here, we can press

	# subtract cost
	GameplayManager.gems_total[Constants.GemTier.TIER1] -= cost_per_level[level]
	GameplayManager.gems_updated.emit()
	# add upgrade
	level += 1
	_update_text()
	GameplayManager.upgrades[upgrade_type] = level

func _update_text() -> void:
	_label.text = "%s/%s" % [level, cost_per_level.size()]

func _update_line() -> void:
	var parent_upgrade_button : UpgradeButton = get_parent() as UpgradeButton
	_line.clear_points()
	if parent_upgrade_button:
		var parent_pos : Vector2 = parent_upgrade_button.global_position + parent_upgrade_button.size/2
		var self_pos : Vector2 = self.global_position + self.size/2
		_line.add_point(Vector2.ZERO)
		_line.add_point(parent_pos-self_pos)
