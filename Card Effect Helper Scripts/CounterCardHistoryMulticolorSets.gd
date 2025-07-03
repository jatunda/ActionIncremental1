class_name CounterCardHistoryMulticolorSets
extends Counter

@export_flags("Fire", "Water", "Earth", "Air", "Light", "Dark", "None")
var elements : int = 0

func get_count() -> int:
	if elements == 0:
		print_debug("no elements selected, automatically returning -1")
		return -1

	var counts : Dictionary[Constants.Element, int] = {}
	if elements & 1: 
		counts[Constants.Element.FIRE] = count_cards_of_element(Constants.Element.FIRE)
	if elements & 2: 
		counts[Constants.Element.WATER] = count_cards_of_element(Constants.Element.WATER)
	if elements & 4: 
		counts[Constants.Element.EARTH] = count_cards_of_element(Constants.Element.EARTH)
	if elements & 8: 
		counts[Constants.Element.AIR] = count_cards_of_element(Constants.Element.AIR)
	if elements & 16: 
		counts[Constants.Element.LIGHT] = count_cards_of_element(Constants.Element.LIGHT)
	if elements & 32: 
		counts[Constants.Element.DARK] = count_cards_of_element(Constants.Element.DARK)
		
	if counts.size() == 0:
		print_debug("no elements selected, automatically returning -1")
		return -1

	print_debug(counts)
	
	return counts.values().min()


## to be overridden by child classes
## [br]format: "if {description} is greater than {other description}"
## [br]format: "for each {description}, do effect"
func _get_description() -> String:
	return "invoked runes of each element"


func count_cards_of_element(element : Constants.Element) -> int:
	return GameplayManager.card_history.filter(
				func(x:CardState): return x.element==element
			).size()
