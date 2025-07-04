@tool
class_name UpgradeButton
extends TextureButton

@export var upgrade : Upgrade = null
@export var _parent_upgrade_button : UpgradeButton
@export var prerequisite_type : ParentUnlockPrerequisite = ParentUnlockPrerequisite.SingleLevel
@export var wall_tier_prereq : int
@export var cost_gem_type : Constants.GemTier
@export var cost_per_level : Array[int] = [1]

@export_group("Self References")
@export var faded_line_gradient : Gradient
@export var _label : Label
@export var _line : Line2D
@export var _background : TextureRect
@export var _border : NinePatchRect  

@export_group("Debug")
@export var should_print_debug : bool = false

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

var max_level : int:
	get: return cost_per_level.size()
var _state : State = State.NotShown
var children_upgrade_buttons : Array[UpgradeButton] = []

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_line_locations()
		return 

	pressed.connect(_on_pressed)

	# assign self as child of parent button
	if _parent_upgrade_button:
		if _parent_upgrade_button.children_upgrade_buttons == null:
			_parent_upgrade_button.children_upgrade_buttons = []
		_parent_upgrade_button.children_upgrade_buttons.append(self)
	
	# two-way link of my upgrade to my parent's upgrade
	if _parent_upgrade_button and upgrade and _parent_upgrade_button.upgrade:
		upgrade.parent_ubid = _parent_upgrade_button.upgrade.ubid
		_parent_upgrade_button.upgrade.children_upgrades[upgrade.ubid] = upgrade

	# register upgrade with UpgradeManager
	if upgrade.level > 0:
		UpgradeManager.upgrades[upgrade.ubid] = upgrade

	# if i am a root node, register with wall_tier updates
	if not _parent_upgrade_button:
		GameplayManager.wall_tier_updated.connect(_update_button)

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

	if upgrade.level >= max_level:
		print_debug("can't buy maxed upgrade: %s" % Upgrade.ubid_to_string(upgrade.ubid))
		return

	if GameplayManager.gems_total.get_or_add(cost_gem_type,0) < cost_per_level[upgrade.level]:
		print_debug("can't afford %s" % Upgrade.ubid_to_string(upgrade.ubid))
		return

	# if we are here, we can press

	# subtract cost
	GameplayManager.gems_total[cost_gem_type] -= cost_per_level[upgrade.level]
	GameplayManager.gems_updated.emit()

	# add/update upgrade
	upgrade.level += 1
	UpgradeManager.upgrades[upgrade.ubid] = upgrade

	# wall upgrades need to be immediately applied so that buttons of the tier can be unlocked
	if upgrade.upgrade_type == Upgrade.Type.WALL:
		GameplayManager.wall_tier = int(upgrade.magnitude)
	
	_update_button()
	_update_line_locations()
 


func _update_line_locations() -> void:
	_line.clear_points()
	if _parent_upgrade_button:
		var parent_pos : Vector2 = _parent_upgrade_button.global_position + _parent_upgrade_button.size/2
		var self_pos : Vector2 = self.global_position + self.size/2
		_line.add_point(parent_pos-self_pos)
		_line.add_point(Vector2.ZERO)

func _update_button() -> void:

	_state = _get_state_based_on_parent()

	_print_debug("update button %s: %s" % [
			Upgrade.ubid_to_string(upgrade.ubid),
			state_to_string(_state)])

	# disable/enable color
	if _state == State.Enabled:
		self_modulate = Color.WHITE
		_label.self_modulate = Color.WHITE
		_border.self_modulate = Color.WHITE
	else:
		self_modulate = Color.GRAY
		_label.self_modulate = Color.GRAY
		_border.self_modulate = Color.GRAY

	# show or no show
	if _state == State.NotShown:
		_set_button_alpha(0.0)
		tooltip_text = ""
	else:
		_set_button_alpha(1.0)
		tooltip_text = _get_tooltip_text_internal()

	# line or no line
	if _parent_upgrade_button:
		if _parent_upgrade_button._state == State.NotShown:
			_line.self_modulate.a = 0
		else:
			_line.self_modulate.a = 1
			_line.gradient = null
			if _state == State.NotShown:
				_line.gradient = faded_line_gradient

	# update text
	_label.text = "%s/%s" % [upgrade.level, max_level]

	# update children_upgrade_buttons
	for child in children_upgrade_buttons:
		var child_upgrade_button : UpgradeButton = child as UpgradeButton
		if child_upgrade_button:
			child_upgrade_button._update_button()



func _get_state_based_on_parent() -> State:

	if wall_tier_prereq > GameplayManager.wall_tier:
		return State.NotShown

	# no parent means are are enabled (root upgrade)
	if _parent_upgrade_button == null:
		return State.Enabled
	
	# if our parents are not even enabled, then we should hide
	var parent_state : State = _parent_upgrade_button._state
	if parent_state == State.ShownDisabled or parent_state == State.NotShown:
		return State.NotShown
	
	# parent is enabled. show ourselves. Determine if we are unlocked based on threshold
	var threshold:int = _get_parent_unlock_threshold()
	
	if _parent_upgrade_button.upgrade.level >= threshold:
		return State.Enabled
	else:
		return State.ShownDisabled

func _get_parent_unlock_threshold() -> int:
	if _parent_upgrade_button == null:
		return 0
	var threshold = 1
	if prerequisite_type == ParentUnlockPrerequisite.MaxLevel:
		threshold = _parent_upgrade_button.max_level
	elif prerequisite_type == ParentUnlockPrerequisite.HalfLevel:
		threshold = int(_parent_upgrade_button.max_level/2.0) 
	return max(threshold, 1)


func _get_tooltip_text_internal() -> String:
	if _state == State.NotShown:
		return ""
	var output : String = "%s" % [Upgrade.ubid_to_string(upgrade.ubid)]
	if _state == State.ShownDisabled:
		output += 	"\n%s %s/%s to Unlock" % [
			Upgrade.ubid_to_string(_parent_upgrade_button.upgrade.ubid), #parent upgrade name
			_get_parent_unlock_threshold(), #threshold
			_parent_upgrade_button.max_level #parent max leve
		]
	
	elif _state == State.Enabled:
		if upgrade.level >= max_level:
			output += "\nMax Level"
		else:
			var gem_type_string : String = "Gems"
			if cost_gem_type == Constants.GemTier.WALL:
				gem_type_string = "Wall Gems"
			output += 	"\nCost: %s %s" % [cost_per_level[upgrade.level], gem_type_string]
	return output 

func _set_button_alpha(a : float) -> void:
	self_modulate.a = a
	_label.self_modulate.a = a
	_background.self_modulate.a = a
	_border.self_modulate.a = a

func _print_debug(v : Variant) -> void:
	if should_print_debug:
		print_debug(v)

static func state_to_string(p_state: State) -> String:
	return State.keys()[State.values().find(p_state)]
