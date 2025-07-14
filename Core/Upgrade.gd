class_name Upgrade
extends Resource

## unique button identifier (one for each upgrade button, no repeats please)
enum UBID 
{
	NONE = 0,

	# basic stats - capacity
	# hundreds represent tiers
	CAPACITY_T0_1 = 1000,
	CAPACITY_T0_2,

	CAPACITY_T1_1 = 1100,
	CAPACITY_T1_2,
	CAPACITY_T1_3,
	CAPACITY_T1_4,

	# basic stats - time
	# hundreds represent tiers
	TIME_T0_1 = 2000,
	TIME_T0_2,
	
	TIME_T1_1 = 2100,
	TIME_T1_2,
	TIME_T1_3,
	TIME_T1_4,

	# basic stats - draft size
	DRAFT_SIZE_T0 = 3000,
	DRAFT_SIZE_T1 = 3001,

	RARE_DRAFT_SIZE_1 = 3100,

	# basic stats - skips
	SKIPS_T1_1 = 3500,
	
	# adding cards 
	# hundreds groups represent elements
	CARD_ADD_WIND_1 = 4000,
	CARD_ADD_WIND_2,
	CARD_ADD_WIND_3,

	CARD_ADD_FIRE_1 = 4100,
	CARD_ADD_FIRE_2,
	CARD_ADD_FIRE_3,
	
	CARD_ADD_WATER_1 = 4200,
	CARD_ADD_WATER_2,
	CARD_ADD_WATER_3,
	
	CARD_ADD_EARTH_1 = 4300,
	CARD_ADD_EARTH_2,
	CARD_ADD_EARTH_3,

	CARD_ADD_LIGHT_1 = 4400,
	CARD_ADD_LIGHT_2,
	CARD_ADD_LIGHT_3,

	CARD_ADD_DARK_1 = 4500,
	CARD_ADD_DARK_2,
	CARD_ADD_DARK_3,
	
	# upgrade cards
	# hundreds grouped by element
	# every new card in the element goes up by 10
	CARD_UPGRADE_FIRE_1_p = 5000,
	CARD_UPGRADE_FIRE_1_pp,
	
	CARD_UPGRADE_WIND_1_p = 5100,
	
	CARD_UPGRADE_WATER_1_p = 5200,
	
	CARD_UPGRADE_EARTH_1_p = 5300,

		
	# start of run statuses
	# +100 for each status type
	# 
	STATUS_STR_T0_1 = 6000,
	STATUS_STR_T1_1,
	STATUS_STR_T1_2,

	STATUS_FLOW_T0_1 = 6100,
	STATUS_FLOW_T1_1,
	STATUS_FLOW_T1_2,

	STATUS_CORES_T1_1 = 6200,
	STATUS_CORES_T1_2,


	# wall
	WALL_T0 = 7000,
	WALL_T1,

	# Feature Unlocks
	UNLOCK_RARES = 8000,
	# start of run drafts ?

	# other?
}

enum Type {
	NONE = 0,
	CAPACITY = 100,
	TIME = 200,
	DRAFT_SIZE = 300,
	RARE_DRAFT_SIZE = 301,
	SKIP = 310,
	STATUS = 400,
	CARD_ADD = 500,
	CARD_REPLACE = 600,
	WALL = 700,
	UNLOCK_FEATURE = 800,
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
		Type.RARE_DRAFT_SIZE:
			GameplayManager.rare_draft_size += int(magnitude * level)
		Type.SKIP:
			GameplayManager.skips += int(magnitude * level)

		Type.STATUS:
			# using _add_status here instead of _apply_status because we want it to happen
			# immediately, regardless of the type of status_type
			# because it's the start of the game
			StatusManager._add_status(status_type, level)

		Type.CARD_ADD:
			GameplayManager.card_offering_manager.add_common_offering(card_1)
			#print("adding card from Ubid:%s, card:%s" % [ubid_to_string(ubid), card_1.name])
		Type.CARD_REPLACE:
			GameplayManager.card_offering_manager.replace_card(card_1, card_2)
		
		Type.WALL:
			GameplayManager.wall_tier = int(magnitude)
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
