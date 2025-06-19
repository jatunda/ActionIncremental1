extends Node
## Global state/functionality
## For stuff that needs to persist between the 
## drafting scene and the upgrades scene.

signal draws_left_changed(new_draws_left:int)
signal capacity_left_changed(new_capacity_left:int)
signal gems_changed(new_gems:int)
signal card_history_update(card_history:Array[Card])

var drafting_manager : DraftingManager = null

var draws_max: int = 10
var draws_left: int = 10 :
	get: 
		return draws_left
	set(value):
		draws_left = max(0, value)
		draws_left_changed.emit(draws_left)

var capacity_max : int = 20
var capacity_left: int = 20 :
	get: 
		return capacity_left
	set(value):
		capacity_left = max(0,value)
		capacity_left_changed.emit(capacity_left)

var gems: int = 0 :
	get:
		return gems
	set(value):
		gems = max(0, value)
		gems_changed.emit(gems)

var card_history : Array[Card] = [] :
	get:
		return card_history
	set(value):
		card_history = value
		card_history_update.emit(card_history)
		
