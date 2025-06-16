class_name CardEffect
extends Resource

var description : String :
    get: 
        return _get_description()

## To be overridden by specific effect implementations.
func apply_effect() -> void:
    # this method is to be overridden by subclasses
    pass

func _get_description() -> String:
    # this method is to be overridden by subclasses
    return ""
