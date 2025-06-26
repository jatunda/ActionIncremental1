## Registers self with GameplayManager on creation

class_name DraftingManager
extends Control

@export var _rendered_card_scene : PackedScene
var _current_offered_cards : Array[Card] 
var num_cards_played_this_turn : int

@onready var _card_offering_manager: CardOfferingManager = $CardOfferingManager
@onready var _rendered_cards_holder : HBoxContainer = $VBoxContainer/RenderedCardsHolder
@onready var _end_run_button : Button = $VBoxContainer/EndRunButton
@onready var _run_summary : RunSummary = $RunSummary
@onready var _runes_chosen_display : OverlappingImageDisplay = $VBoxContainer/HBoxContainer/OverlappingImageDisplay
@onready var _skip_button : Button = $VBoxContainer/Control2/HBoxContainer/SkipButton

func _ready() -> void:
	SceneManager.current_scene = self
	GameplayManager.drafting_manager = self
	GameplayManager.draws_left = GameplayManager.draws_max
	GameplayManager.capacity_left = GameplayManager.capacity_max
	_end_run_button.pressed.connect(end_run)
	_run_summary.start_new_run.connect(start_run)
	_skip_button.pressed.connect(try_skip)
	GameplayManager.card_history_add_one.connect(_runes_chosen_display._on_card_history_add_one)
	GameplayManager.card_history_reset.connect(_runes_chosen_display._on_card_history_reset)
	start_run()
	
## return whether the card was played or not
func try_play_card(card : Card) -> bool:

	var can_play : bool = true
	if card.played:
		print_debug("can't play a card that's already been played")
		can_play = false
	if(card.cost > GameplayManager.capacity_left):
		print_debug("not enough capacity for this rune")
		# run animation for not allowed
		can_play = false
	if(num_cards_played_this_turn > 100):
		print_debug("Can't play more cards - already played 100 cards this turn")
		can_play = false

	# if click is not allowed, 
	if can_play == false:
		# make the card do a not allowed animation and return
		return false



	# apply card effect(s)
	card.played = true
	add_card_to_history(card)
	num_cards_played_this_turn += 1
	GameplayManager.capacity_left -= card.cost
	card.applyEffects()
	
	return true

func _on_card_clicked(renderedCard: RenderedCard) -> void:

	if(GameplayManager.draws_left < 1):
		# should never reach this code...
		# if we reach here, end the session
		print_debug("no draws left! ending run")
		end_run()
		return

	var was_card_played : bool = try_play_card(renderedCard.card_modified)
	if(was_card_played == false) :
		# play effect for failing to play card
		return

	# play animation for clicking on rune (collect resources/rune)
	
	# do other things
	end_turn()

func get_and_render_cards() -> void:
	num_cards_played_this_turn = 0
	GameplayManager.draws_left -= 1

	# query the _card_offering_manager and get 3 cards from it
	var draft_size : int = get_draft_size()
	var cards : Array[Card] = _card_offering_manager.get_cards(draft_size)
	
	# spawn/delete renderedCards if need be
	
	# get current renderedCards
	var potential_rendered_cards : Array[Node] = _rendered_cards_holder.get_children()
	var rendered_cards : Array[RenderedCard] = []
	for potential_rendered_card in potential_rendered_cards: 
		if potential_rendered_card is RenderedCard:
			rendered_cards.append(potential_rendered_card as RenderedCard)

	# count how many nodes we actually showing	
	var num_cards_showing : int = 0
	for rendered_card  in rendered_cards:
		if rendered_card.visible:
			num_cards_showing += 1

	# if we got too many: hide them
	if num_cards_showing > draft_size:
		var num_left_to_hide : int = num_cards_showing - draft_size
		for i in range(rendered_cards.size() - 1, -1, -1):
			if rendered_cards[i].visible:
				rendered_cards[i].visible = false
				rendered_cards[i].card_clicked.disconnect(_on_card_clicked)
				num_left_to_hide -= 1
				if(num_left_to_hide <= 0):
					break

	# if we got not enough: unhide or add until we got enough
	elif num_cards_showing < draft_size:
		var num_left_to_show : int = draft_size - num_cards_showing
		# unhide
		for rendered_card in rendered_cards:
			if(rendered_card.visible == false):
				rendered_card.visible = true
				rendered_card.card_clicked.connect(_on_card_clicked)
				num_left_to_show -= 1
				if num_left_to_show <= 0:
					break
		# add more
		for _i in range(num_left_to_show): 
			var new_rendered_card : RenderedCard = _rendered_card_scene.instantiate()
			_rendered_cards_holder.add_child(new_rendered_card)
			rendered_cards.append(new_rendered_card)
			new_rendered_card.card_clicked.connect(_on_card_clicked)

	# fill the actual rendered card nodes with the correct data
	_current_offered_cards = []
	for i in range(draft_size):
		var original_card : Card = cards[i]
		var offered_card : Card = get_modified_card(cards[i])
		rendered_cards[i].spawnCard(original_card, offered_card)
		_current_offered_cards.append(offered_card)

	# have the cards play their initial render animations
	
## Returns of all the cards on offer
## These cards are the modified version being shown
## (for example, if there is something reducing card cost, 
## the returned card will have reduced cost)
## [br] The optional parameter [card_names_to_exclude] 
## will filter those cards out of the returned cards.
func get_current_offered_cards(card_names_to_exclude:Array[String] = []):
	var output : Array[Card] = []

	# return all cards if none are to excluded
	if card_names_to_exclude == null or card_names_to_exclude.size() == 0:
		return _current_offered_cards

	# go through all cards, return all except those excluded
	for card in _current_offered_cards:
		var i : int = card_names_to_exclude.find_custom(func(s:String)->bool: return s == card.name)
		if i == -1: # not in our exclude list
			output.append(card)
	return output

func try_skip() -> void:
	if GameplayManager.skips <= 0:
		print_debug("can't skip! no skips left")
		return
	GameplayManager.skips -= 1
	print_debug("skip")
	end_turn()

func end_turn() -> void:
	# play animation for removing unclicked cards
	# wait for animations to finish (or maybe just a set time?)

	# end of turn effects
	StatusManager.tick_statuses()

	# check if game should end
	if(GameplayManager.draws_left < 1):
		print_debug("no draws left! ending run")
		end_run()
		return
		
	get_and_render_cards()
	# Start of turn effects go here
	

func end_run() -> void:
	# show run summary
	_run_summary.show()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for key in GameplayManager.gems_this_run.keys():
		var value : int = GameplayManager.gems_this_run[key]
		if not GameplayManager.gems_total.has(key):
			GameplayManager.gems_total[key] = 0
		GameplayManager.gems_total[key] += value
	GameplayManager.gems_updated.emit()

	# disable card buttons
	pass

func start_run() -> void:
	_run_summary.hide()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_STOP

	GameplayManager.gems_this_run = {Constants.GemTier.TIER1:0}
	GameplayManager.gems_updated.emit()
	GameplayManager.capacity_left = GameplayManager.capacity_max
	GameplayManager.draws_left = GameplayManager.draws_max
	GameplayManager.skips = 3

	GameplayManager.card_history = [] 
	GameplayManager.card_history_reset.emit()
	StatusManager.clear_all_statuses()

	_card_offering_manager.populate_offerings()

	get_and_render_cards()
	# start of turn effects go here
	#reenable card buttons

func add_card_to_history(card:Card) -> void:
	GameplayManager.card_history.append(card)
	GameplayManager.card_history_add_one.emit()

func get_modified_card(p_card : Card) -> Card:
	var new_card = Card.new()
	new_card.cost = get_modified_card_cost(p_card)
	new_card.name = get_modified_card_name(p_card)
	new_card.image = get_modified_card_image(p_card)
	new_card.rarity = get_modified_card_rarity(p_card)
	new_card.element = get_modified_card_element(p_card)
	new_card.effects = get_modified_card_effects(p_card)
	return new_card

func get_modified_card_name(card: Card) -> String:
	return card.name

func get_modified_card_cost(card : Card) -> int:
	var cost = card.cost
	if(StatusManager.has_status(Status.Type.REDUCE_NEXT_CARD_COST)):
		cost -= StatusManager.get_status_value(Status.Type.REDUCE_NEXT_CARD_COST)
	return max(0, cost)

func get_modified_card_image(card: Card) -> Texture2D:
	return card.image

func get_modified_card_rarity(card: Card) -> Constants.Rarity:
	return card.rarity

func get_modified_card_element(card: Card) -> Constants.Element:
	return card.element

func get_modified_card_effects(card: Card) -> Array[CardEffect]:
	return card.effects.duplicate(true)

func _notification(what: int) -> void:
	match what:
		# godot's version of a destructor
		NOTIFICATION_PREDELETE:
			GameplayManager.drafting_manager = null

func get_draft_size() -> int:
	# might want to limit the draft size max (5? 6?)
	var draft_size = 3 + StatusManager.get_status_value(Status.Type.DRAFT_SIZE)
	return max(1,draft_size)
	
