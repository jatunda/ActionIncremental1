class_name Constants
extends Object

enum Rarity {
    COMMON,
    UNCOMMON,
    RARE,
    EPIC,
    LEGENDARY,
}

enum Element {
    FIRE,
    WATER,
    EARTH,
    AIR,
    LIGHT,
    DARK,
}

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