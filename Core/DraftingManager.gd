## Registers self with GameplayManager on creation

class_name DraftingManager
extends Control

@export var _rendered_card_scene : PackedScene
var current_offered_cards : Array[Card] :
	get:
		return current_offered_cards

@onready var _card_offering_manager: CardOfferingManager = $CardOfferingManager
@onready var _rendered_cards_holder : HBoxContainer = $VBoxContainer/RenderedCardsHolder
@onready var _end_run_button : Button = $VBoxContainer/EndRunButton
@onready var _run_summary : RunSummary = $RunSummary
@onready var _runes_chosen_display : OverlappingImageDisplay = $VBoxContainer/HBoxContainer/OverlappingImageDisplay

func _ready() -> void:
	GameplayManager.drafting_manager = self
	GameplayManager.draws_left = GameplayManager.draws_max
	GameplayManager.capacity_left = GameplayManager.capacity_max
	_end_run_button.pressed.connect(end_run)
	_run_summary.start_new_run.connect(start_run)
	GameplayManager.card_history_add_one.connect(_runes_chosen_display._on_card_history_add_one)
	GameplayManager.card_history_reset.connect(_runes_chosen_display._on_card_history_reset)
	start_run()
	
## return whether the card was played or not
func try_play_card(card : Card) -> bool:
	# if click is not allowed, make the card do a not allowed thing and return
	if(card.cost > GameplayManager.capacity_left):
		print("not enough capacity for this rune")
		# run animation for not allowed
		return false

	# apply card effect(s)
	add_card_to_history(card)
	GameplayManager.capacity_left -= card.cost
	card.applyEffects()
	
	return true

func _on_card_clicked(renderedCard: RenderedCard) -> void:

	if(GameplayManager.draws_left < 1):
		# should never reach this code...
		# if we reach here, end the session
		print("no draws left! ending run")
		end_run()
		return

	var playedCard : bool = try_play_card(renderedCard.card_modified)
	if(playedCard == false) :
		# play effect for failing to play card
		return

	# past this point, the click was allowed, card was played

	# play animation for clicking on rune (collect resources/rune, remove other cards)
	# wait for animations to finish (or maybe just a set time?)

	# end of turn effects
	StatusManager.tick_statuses()

	# check if game should end
	if(GameplayManager.draws_left < 1):
		print("no draws left! ending run")
		end_run()
		return
		
	get_and_render_cards()
	# Start of turn effects go here
	pass

func get_and_render_cards() -> void:
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
	current_offered_cards = []
	for i in range(draft_size):
		var original_card : Card = cards[i]
		var offered_card : Card = get_modified_card(cards[i])
		rendered_cards[i].spawnCard(original_card, offered_card)
		current_offered_cards.append(offered_card)

	# have the cards play their initial render animations
	

func end_run() -> void:
	# show run summary
	_run_summary.show()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# disable card buttons
	pass

func start_run() -> void:
	_run_summary.hide()
	_run_summary.mouse_filter = Control.MOUSE_FILTER_STOP

	GameplayManager.gems = 0
	GameplayManager.capacity_left = GameplayManager.capacity_max
	GameplayManager.draws_left = GameplayManager.draws_max

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
