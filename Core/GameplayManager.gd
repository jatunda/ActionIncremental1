extends Node
## Global state/functionality. Godot Singleton
## For stuff that needs to persist between the 
## drafting scene and the upgrades scene.

signal draws_left_updated()
signal capacity_left_updated()
signal gems_updated()
signal skips_updated()
signal card_history_add_one()
signal card_history_reset()

var drafting_manager : DraftingManager = null

var draws_max: int = 10
var draws_left: int = 10 :
	get: 
		return draws_left
	set(value):
		draws_left = max(0, value)
		draws_left_updated.emit()

var capacity_max : int = 20
var capacity_left: int = 20 :
	get: 
		return capacity_left
	set(value):
		capacity_left = max(0,value)
		capacity_left_updated.emit()

var gems_total : Dictionary[Constants.GemTier, int]:
	get: 
		return gems_total
	set(value):
		gems_total = value
		gems_updated.emit()

var gems_this_run : Dictionary[Constants.GemTier, int]:
	get: return gems_this_run
	set(value): 
		gems_this_run = value
		gems_updated.emit()

var card_history : Array[Card] = [] 
		
var skips : int = 0 :
	get:
		return skips
	set(value):
		skips = max(0, value)
		skips_updated.emit()
	
var upgrades : Dictionary[Constants.UpgradeType, int] = {}