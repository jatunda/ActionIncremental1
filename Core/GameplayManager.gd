extends Node
## Global state/functionality. Godot Singleton
## For stuff that needs to persist between the 
## drafting scene and the upgrades scene.

signal draws_left_changed(new_draws_left:int)
signal capacity_left_changed(new_capacity_left:int)
signal gems_changed(new_gems:int)
signal skips_changed(new_skips:int)
signal card_history_add_one()
signal card_history_reset()

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

var card_history : Array[Card] = [] 
		
var skips : int = 0 :
	get:
		return skips
	set(value):
		skips = max(0, value)
		skips_changed.emit(skips)
	