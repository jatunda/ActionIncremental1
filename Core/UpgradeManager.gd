extends Node

## unique button ID
enum UBID 
{
	CHANGE_ME = 0,

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

	# start of run drafts

	# other?
}

var upgrades : Dictionary[UBID, int] = {}

func _ready() -> void:
	GameplayManager.upgrade_manager = self


func ubid_to_string(ubid : UBID) -> String:
	var output : String = UBID.keys()[UBID.values().find(ubid)].to_lower()
	return output.replace("_", " ")

func apply_upgrades() -> void:
	print_debug("applying all upgrades")
	for ubid in upgrades:
		_apply_effect(ubid, upgrades[ubid])

func _apply_effect(ubid:UBID, level:int) -> void:
	print("applying upgrade: %s, level %s" % [ubid_to_string(ubid), level])

	match ubid:
		UBID.CAPACITY_T0_1, UBID.CAPACITY_T0_2: 
			GameplayManager.capacity_left += 2 * level

		UBID.TIME_T0_1, UBID.TIME_T0_2:
			GameplayManager.time_left += 1 * level

		UBID.DRAFT_SIZE_T0:
			GameplayManager.draft_size += level

		UBID.CARD_ADD_WIND_1:
			pass

		UBID.CARD_ADD_FIRE_1:
			pass
		UBID.CARD_ADD_EARTH_1:
			pass

		UBID.CARD_ADD_WATER_1:
			pass

			
		UBID.CARD_UPGRADE_FIRE_1_1:
			pass

		UBID.STATUS_STR_T0_1:
			pass
		UBID.STATUS_FLOW_T0_1:
			pass
		_:
			pass
	pass
