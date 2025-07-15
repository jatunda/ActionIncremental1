## Registers self with GameplayManager on creation 
## Responsible for turn order and coordinating between different classes for drafting screen gameplay
class_name DraftingManager
extends Control

signal on_turn_number_change

const STARTING_CAPACITY : int = 3
const STARTING_DRAFT_SIZE : int = 1
const STARTING_TIME : int = 3
const STARTING_SKIPS : int = 0

@onready var rendered_card_manager : RenderedCardManager = $VBoxContainer/RenderedCardsHolder
@onready var _end_run_confirm_screen : ConfirmEndRunScreen = $ConfirmEndRun
@onready var _run_summary : RunSummary = $RunSummary
@onready var _runes_chosen_display : OverlappingImageDisplay = $VBoxContainer/HBoxContainer/OverlappingImageDisplay
@onready var _skip_button : Button = $VBoxContainer/Control2/HBoxContainer/SkipButton

var _current_offered_cards : Array[CardState]  
var num_cards_played_this_turn : int
var turn_number : int :
	get:
		return turn_number
	set(value):
		turn_number = value
		on_turn_number_change.emit()


func _init() -> void:
	GameplayManager.drafting_manager = self


func _ready() -> void:
	SceneManager.current_scene = self
	GameplayManager.drafting_manager = self
	_end_run_confirm_screen.end_run_pressed.connect(end_run)
	_run_summary.start_new_run.connect(start_run)
	_skip_button.pressed.connect(try_skip)
	GameplayManager.card_history_add_one.connect(_runes_chosen_display._on_card_history_add_one)
	GameplayManager.card_history_reset.connect(_runes_chosen_display._on_card_history_reset)
	start_run()

func _notification(what: int) -> void:
	match what:
		# godot's version of a destructor
		NOTIFICATION_PREDELETE:
			GameplayManager.drafting_manager = null

func start_run() -> void:
	# hide run summary
	_run_summary.hide()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# initialize variables
	GameplayManager.gems_this_run = {Constants.GemTier.TIER1:0}
	GameplayManager.gems_updated.emit()
	GameplayManager.capacity_left = STARTING_CAPACITY
	GameplayManager.time_left = STARTING_TIME
	GameplayManager.skips = STARTING_SKIPS
	GameplayManager.draft_size = STARTING_DRAFT_SIZE
	GameplayManager.card_history = [] 
	GameplayManager.card_history_reset.emit()
	StatusManager.clear_all_statuses()
	GameplayManager.card_offering_manager.populate_starting_offerings()
	turn_number = 0

	# apply upgrades
	UpgradeManager.apply_upgrades()

	GameplayManager.card_offering_manager.reset_cards()

	# start of turn stuff
	start_turn()

func start_turn() -> void:

	# turn counter
	turn_number += 1

	# initialize variables
	num_cards_played_this_turn = 0

	# get the next draft from card_offering_manager, fill in _current_offered_cards
	var cardStates : Array[CardState] = _get_draft()
	var num_cards_to_show = min(GameplayManager.draft_size, cardStates.size())
	_current_offered_cards = []
	for i in range(num_cards_to_show):
		var offered_card : CardState = CardModifier.get_modified_card(cardStates[i])
		_current_offered_cards.append(offered_card)
	
	# render cards
	rendered_card_manager.render_cards(_current_offered_cards)

	# start of turn effects go here. 
	StatusManager.trigger_status_effects(Status.TriggerTiming.START_OF_TURN)

	# (re)enable card buttons (or the flag that makes the signal do nothing?)

func end_turn() -> void:
	# disable card buttons (or just have a flag that makes the signal do nothing?)

	# play animation for removing unclicked cards
	# wait for animations to finish (or maybe just a set time?)

	# end of turn effects
	StatusManager.trigger_status_effects(Status.TriggerTiming.END_OF_TURN)

	# count down statuses
	StatusManager.tick_statuses()

	# tick turn count and time
	GameplayManager.time_left -= 1

	# check if game should end
	if(GameplayManager.time_left < 1):
		print_debug("no time left! ending run")
		end_run()
		return
		
	start_turn()
	
func end_run() -> void:
	# show run summary
	_run_summary.show()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# add our earned gems to the gem total
	for key in GameplayManager.gems_this_run.keys():
		var value : int = GameplayManager.gems_this_run[key]
		if not GameplayManager.gems_total.has(key):
			GameplayManager.gems_total[key] = 0
		if key == Constants.GemTier.WALL: 
			# wall gems are special, they do not add on top of each other
			GameplayManager.gems_total[key] = max(GameplayManager.gems_total[key], value)
		else:
			GameplayManager.gems_total[key] += value
	GameplayManager.gems_updated.emit()

func _get_draft() -> Array[CardState]:

	# based on current wall_tier, check if we want a wall instead of a normal draft.
	# some copy paste inefficiency, because it allows quicker gameplay iteration.
	var is_wall_draft : bool = false

	if GameplayManager.wall_tier == 0:
		if turn_number >= 10:
			is_wall_draft = true
	
	elif GameplayManager.wall_tier == 1:
		if turn_number >= 20:
			is_wall_draft = true

	elif GameplayManager.wall_tier == 2:
		if turn_number >= 30:
			is_wall_draft = true

	elif GameplayManager.wall_tier == 3:
		if turn_number >= 40:
			is_wall_draft = true

	elif GameplayManager.wall_tier > 3: # wall_tier = endless
		if turn_number >= 50 and turn_number % 10 == 0:
			is_wall_draft = true

	if is_wall_draft:
		return GameplayManager.card_offering_manager.get_wall_draft(
					GameplayManager.draft_size, GameplayManager.wall_tier)		

	return GameplayManager.card_offering_manager.get_draft(GameplayManager.draft_size)

## return true if card was successfully played, else false
## only for the backend of playing a card
func try_play_card(card_state : CardState) -> bool:

	var can_play_this_card : bool = can_play_card(card_state)

	if can_play_this_card == false:
		return false

	# apply card effect(s)
	card_state.played = true
	add_card_to_history(card_state)
	num_cards_played_this_turn += 1
	GameplayManager.capacity_left -= card_state.cost
	StatusManager.trigger_status_effects(Status.TriggerTiming.EVERY_CARD_PLAYED)
	card_state.applyEffects()

	return true


func can_play_card(card_state: CardState) -> bool:
	if card_state == null:
		print_debug("cannot play a null card!!")
		return false
	if card_state.played:
		print_debug("can't play a card that's already been played")
		return false
	if(card_state.cost > GameplayManager.capacity_left):
		print_debug("not enough capacity for this rune")
		return false
	if(num_cards_played_this_turn > 100):
		print_debug("Can't play more cards - already played 100 cards this turn")
		return false
	if card_state.play_condition != null:
		if  card_state.play_condition.is_satisfied() == false:
			print_debug("can't play - card play condition not met.")
			return false
		else:
			#print_debug("card play condition met")
			pass

	return true
	

func _on_card_clicked(renderedCard: RenderedCard) -> void:
	var was_card_played : bool = try_play_card(renderedCard.card_state)
	StatusManager.trigger_status_effects(Status.TriggerTiming.CLICKED_CARD_PLAYED)
	if(was_card_played == false) :
		# play card effect for trying to play a card you can't
		return

	# play animation for clicking on rune (collect resources/rune)
	
	# end turn
	end_turn()
	

func try_skip() -> void:
	if GameplayManager.skips <= 0:
		print_debug("can't skip! no skips left")
		return
	GameplayManager.skips -= 1
	print_debug("skip")
	end_turn()


## Returns of all the cards on offer
## These cards are the modified version being shown
## (for example, if there is something reducing card cost, 
## the returned card will have reduced cost)
## [br] The optional parameter [card_names_to_exclude] 
## will filter those cards out of the returned cards.
func get_current_offered_cards(card_names_to_exclude:Array[String] = []) -> Array[CardState]:
	var output : Array[CardState] = []

	# return all cards if none are to excluded
	if card_names_to_exclude == null or card_names_to_exclude.size() == 0:
		return _current_offered_cards

	# go through all cards, return all except those excluded
	for card in _current_offered_cards:
		var i : int = card_names_to_exclude.find_custom(func(s:String)->bool: return s == card.name)
		if i == -1: # not in our exclude list
			output.append(card)
	return output


func add_card_to_history(card_state:CardState) -> void:
	GameplayManager.card_history.append(card_state)
	GameplayManager.card_history_add_one.emit()
