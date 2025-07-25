class_name Constants
extends Object

enum Rarity {
    COMMON,
    UNCOMMON,
    RARE,
    WALL,
}

enum Element {
    FIRE,
    WATER,
    EARTH,
    AIR,
    LIGHT,
    DARK,
    NONE,
}

static func element_to_string(element : Element) -> String:
    return Element.keys()[element].to_lower()

static func element_to_color(element: Element) -> Color:
    match element:
        Element.FIRE:
            return Color.RED
        Element.WATER:
            return Color.BLUE
        Element.EARTH:
            return Color.SANDY_BROWN
        Element.AIR:
            return Color.GREEN
        Element.LIGHT:
            return Color.YELLOW
        Element.DARK:
            return Color.LIGHT_GRAY
        _: 
            return Color.WHITE

enum BooleanOperator {
	AND,
	OR,
	XOR,
}

static func boolean_operator_to_string(boolean_operator : BooleanOperator) -> String:
    return BooleanOperator.keys()[boolean_operator].to_lower()

enum GemTier {
    TIER1,
    WALL,
}

static func gem_tier_to_string(gem_tier : GemTier) -> String:
    var output : String = GemTier.keys()[gem_tier].to_lower()
    return output.replace("_", " ")

enum EndRunReason {
    UNDEFINED,
    OUT_OF_TIME,
    MANUAL_END,
    WALL_CLEARED,
}
