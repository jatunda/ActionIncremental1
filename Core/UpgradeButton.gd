@tool
class_name UpgradeButton
extends TextureButton


@export var upgrade_type : Constants.UpgradeType
@export var prerequisite_type : ParentUnlockPrerequisite = ParentUnlockPrerequisite.SingleLevel
@export var cost_gem_type : Constants.GemTier
@export var cost_per_level : Array[int] = [1]
@export var faded_line_gradient : Gradient

@export var _label : Label
@export var _line : Line2D

enum State {
	Enabled, 
	ShownDisabled, 
	NotShown, 
}

enum ParentUnlockPrerequisite {
	SingleLevel,
	MaxLevel,
	HalfLevel,
}

var level :int = 0
var max_level : int:
	get: return cost_per_level.size()
var _parent_upgrade_button : UpgradeButton
var _state : State = State.NotShown

func _ready() -> void:
	pressed.connect(_on_pressed)
	if GameplayManager.upgrades.has(upgrade_type):
		level = GameplayManager.upgrades[upgrade_type]
	_update_button()
	_update_line_locations()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): # only in editor
		_update_line_locations()

func _on_pressed() -> void:
	if Engine.is_editor_hint(): return

	# if can't press
	if _state != State.Enabled:
		print_debug("this button is not enabled. cannot buy")
		return

	if level >= max_level:
		print_debug("can't buy maxed upgrade: %s" % Constants.upgrade_type_to_string(upgrade_type))
		return

	if GameplayManager.gems_total.get_or_add(Constants.GemTier.TIER1,0) < cost_per_level[level]:
		print_debug("can't afford %s" % Constants.upgrade_type_to_string(upgrade_type))
		return

	# if we here, we can press

	# subtract cost
	GameplayManager.gems_total[Constants.GemTier.TIER1] -= cost_per_level[level]
	GameplayManager.gems_updated.emit()
	# add upgrade
	level += 1
	_update_button()
	_update_line_locations()
	GameplayManager.upgrades[upgrade_type] = level


func _update_line_locations() -> void:
	_parent_upgrade_button = get_parent() as UpgradeButton
	_line.clear_points()
	if _parent_upgrade_button:
		var parent_pos : Vector2 = _parent_upgrade_button.global_position + _parent_upgrade_button.size/2
		var self_pos : Vector2 = self.global_position + self.size/2
		_line.add_point(parent_pos-self_pos)
		_line.add_point(Vector2.ZERO)

func _update_button() -> void:
	_parent_upgrade_button = get_parent() as UpgradeButton

	_state = _get_state_based_on_parent()

	# disable/enable color
	if _state == State.Enabled:
		self_modulate = Color.WHITE
	else:
		self_modulate = Color.GRAY

	# show or no show
	if _state == State.NotShown:
		self_modulate.a = 0
		_label.self_modulate.a = 0
		tooltip_text = ""
	else:
		self_modulate.a = 1
		_label.self_modulate.a = 1
		tooltip_text = _get_tooltip_text_internal()

	# line or no line
	if _parent_upgrade_button:
		if _parent_upgrade_button._state == State.NotShown:
			_line.self_modulate.a = 0
		else:
			_line.self_modulate.a = 1
			_line.gradient = null
			if _state == State.NotShown:
				#_line.self_modulate.a = 0.5
				_line.gradient = faded_line_gradient

	# update text
	_label.text = "%s/%s" % [level, max_level]

	# update children
	for child in get_children():
		var child_upgrade_button : UpgradeButton = child as UpgradeButton
		if child_upgrade_button:
			child_upgrade_button._update_button()


func _get_state_based_on_parent() -> State:

	# no parent means are are enabled (root upgrade)
	if not _parent_upgrade_button:
		return State.Enabled
	
	# if our parents are not even enabled, then we should hide
	var parent_state : State = _parent_upgrade_button._state
	if parent_state == State.ShownDisabled or parent_state == State.NotShown:
		return State.NotShown
	
	# parent is enabled. show ourselves. Determine if we are unlocked based on threshold
	var threshold:int = _get_parent_unlock_threshold()
	
	if _parent_upgrade_button.level >= threshold:
		return State.Enabled
	else:
		return State.ShownDisabled

func _get_parent_unlock_threshold() -> int:
	if not _parent_upgrade_button:
		return 1
	var threshold = 1
	if prerequisite_type == ParentUnlockPrerequisite.MaxLevel:
		threshold = _parent_upgrade_button.max_level
	elif prerequisite_type == ParentUnlockPrerequisite.HalfLevel:
		threshold = int(_parent_upgrade_button.max_level/2.0) 
	return threshold


func _get_tooltip_text_internal() -> String:
	if _state == State.NotShown:
		return ""
	var output : String = "%s" % [Constants.upgrade_type_to_string(upgrade_type)]
	if _state == State.ShownDisabled:
		output += 	"\n%s %s/%s to Unlock" % [
			Constants.upgrade_type_to_string(_parent_upgrade_button.upgrade_type), #parent upgrade name
			_get_parent_unlock_threshold(), #threshold
			_parent_upgrade_button.max_level #parent max leve
		]
	
	elif _state == State.Enabled:
		if level >= max_level:
			output += "\nMax Level"
		else:
			output += 	"\nCost: %s Gems" % [cost_per_level[level]]
	return output 
