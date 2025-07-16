
class_name Util
extends Object

## Adds BBCode tags to the given [content] string. 
## [br] Optionally, can give your tag a value
static func add_BBCode_tag(content:String, tag:String, value:String="") -> String:
	var value_string : String = "" if value.length() < 0 else "=%s" % value
	return "[%s%s]%s[/%s]" % [tag, value_string, content, tag]

static func add_BBCode_tag_with_parameters(content : String, tag : String, tag_parameters : Dictionary = {}) -> String:
	var param_string : String = ""
	for key in tag_parameters:
		param_string += " %s=%s" % [key,tag_parameters[key]]
	return "[%s%s]%s[/%s]" % [tag, param_string, content,tag]

static func add_BBCode_color(content : String, color : Color) -> String :
	return add_BBCode_tag(content, "color", color.to_html())