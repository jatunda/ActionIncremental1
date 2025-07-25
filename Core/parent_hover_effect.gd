extends Node

var has_initial_pos : bool = false
var initial_pos : Vector2
var parent : Node

enum Mode {
	VERTICAL,
	XY_RANDOM,
}

@export var mode : Mode = Mode.VERTICAL
@export var frequency : float = 1.7
@export var amplitude : float = 1.1

func _ready() -> void:
	parent = get_parent()
	initial_pos = parent.position

	match mode: 
		Mode.XY_RANDOM:
			create_tween().tween_callback(_next_tween).set_delay(0.1)

func _next_tween() -> void:
	var tween = create_tween()
	tween.tween_property(parent, "position", _get_new_goal_based_on_prev(parent.position), 1 / frequency * randf_range(0.9, 1.1)).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(_next_tween)

func _process(_delta: float) -> void:
	if not parent:
		return

	if not has_initial_pos:
		initial_pos = parent.position
		has_initial_pos = true

	match mode:
		Mode.VERTICAL:
			parent.position = initial_pos + Vector2(0.0, sin(Time.get_ticks_msec()/1000.0*frequency) * amplitude)


func _get_new_goal_based_on_prev(old_goal : Vector2) -> Vector2:
	if old_goal == Vector2.ZERO or old_goal == initial_pos:
		old_goal = initial_pos + Vector2.ONE.rotated(randf_range(0.0, 2*PI))
	old_goal = old_goal - initial_pos
	var new_goal : Vector2 = -old_goal.normalized()
	new_goal = new_goal.rotated(randf_range(-1, 1))
	new_goal = new_goal * amplitude * randf_range(0.5, 1.0)
	return initial_pos + new_goal
