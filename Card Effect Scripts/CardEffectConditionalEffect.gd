class_name CardEffectConditionalEffect
extends CardEffect





@export var conditional_mode : Constants.BooleanOperator = Constants.BooleanOperator.AND
@export var conditionals : Array[Conditional]
@export var effects : Array[CardEffect]

func _is_satisfied() -> bool:
	var conditional_true_count : int = 0
	for conditional in conditionals:
		if conditional.is_satisfied():
			conditional_true_count += 1

	if conditional_mode == Constants.BooleanOperator.AND and conditional_true_count < conditionals.size():
		return false
	if conditional_mode == Constants.BooleanOperator.OR and conditional_true_count < 1:
		return false
	if conditional_mode == Constants.BooleanOperator.XOR and conditional_true_count != 1:
		return false
	return true

func apply_effect() -> void:
	if(!_is_satisfied()):
		return
	for effect in effects:
		effect.apply_effect()

func _get_description() -> String:
	var conditional_string : String = ""
	var effects_string : String = ""
	var first : bool = true
	for conditional in conditionals:
		if first:
			first = false
		else:
			conditional_string += " %s " % [Constants.boolean_operator_to_string(conditional_mode)]
		conditional_string += conditional.description

	first = true
	for effect in effects:
		if first:
			first = false
		else:
			effects_string += " and "

		effects_string += effect.description
		
	var output = "if %s, %s" % [conditional_string, effects_string]
	if _is_satisfied():
		output = Util.add_BBCode_color(output, Color.YELLOW)
	else:
		output = Util.add_BBCode_color(output, Color.BLACK)
	return output
	
