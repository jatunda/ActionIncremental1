class_name Upgrade
extends Resource

## unique button identifier (one for each upgrade button, no repeats please)
enum UBID 
{
	NONE = 0,

	# basic stats - capacity
	CAPACITY_T0_1 = 1000,
	CAPACITY_T0_2,

	# basic stats - time
	TIME_T0_1 = 2000,
	TIME_T0_2,

	# basic stats - draft size
	DRAFT_SIZE_T0 = 3000,

	# adding cards 
	CARD_ADD_WIND_1 = 4000,
	CARD_ADD_FIRE_1,
	CARD_ADD_EARTH_1,
	CARD_ADD_WATER_1,
	
	# upgrade cards
	CARD_UPGRADE_FIRE_1_1 = 5000,

		
	# start of run statuses
	STATUS_STR_T0_1 = 6000,
	STATUS_FLOW_T0_1,

	# wall
	WALL_T0 = 7000,

	# start of run drafts

	# other?
}

enum Type {
	NONE = 0,
	CAPACITY = 100,
	TIME = 200,
	DRAFT_SIZE = 300,
	STATUS = 400,
	CARD_ADD = 500,
	CARD_REPLACE = 600,
	WALL = 700,
	# ?? Card upgrade?
}



static func ubid_to_string(p_ubid : UBID) -> String:
	var output : String = UBID.keys()[UBID.values().find(p_ubid)].to_lower()
	return output.replace("_", " ")

static func type_to_string(p_upgrade_type : Type) -> String:
	var output : String = Type.keys()[Type.values().find(p_upgrade_type)].to_lower()
	return output.replace("_", " ")

@export var ubid : UBID = UBID.NONE
var parent_ubid : UBID = UBID.NONE
var children_upgrades : Dictionary[UBID, Upgrade] = {}
var level : int = 0
@export var upgrade_type : Type = Type.NONE
## different uses depending on upgrade type. 
@export var magnitude : float = 1.0
@export var status_type : Status.Type = Status.Type.NONE
@export var card_1 : Card = null
@export var card_2 : Card = null

## applies the upgrade effect
func apply_effect() -> void:
	match upgrade_type:

		Type.CAPACITY: 
			GameplayManager.capacity_left += int(magnitude * level)
		Type.TIME:
			GameplayManager.time_left += int(magnitude * level)
		Type.DRAFT_SIZE:
			GameplayManager.draft_size += int(magnitude * level)

		Type.STATUS:
			# using _add_status here instead of _apply_status because we want it to happen
			# immediately, regardless of the type of status_type
			# because it's the start of the game
			StatusManager._add_status(Status.Type.GEM_ADD, level)

		Type.CARD_ADD:
			GameplayManager.card_offering_manager.add_common_offering(card_1)

		Type.CARD_REPLACE:
			GameplayManager.card_offering_manager.replace_card(card_1, card_2)
		
		Type.WALL:
			GameplayManager.wall_tier = Constants.get_next_wall_tier(GameplayManager.wall_tier)
		_:
			pass

func _to_string() -> String:
	return ubid_to_string(ubid)
	# return "UPGRADE{ubid:%s, type:%s, lvl:%s, mag:%s, status:%s, card_1:%s, card_2:%s}" % [
	# 		ubid_to_string(ubid), 
	# 		type_to_string(upgrade_type),
	# 		level,
	# 		magnitude,
	# 		Status.type_to_string(status_type),
	# 		"null" if not card_1 else card_1.name,
	# 		"null" if not card_2 else card_2.name,
	# 		]
