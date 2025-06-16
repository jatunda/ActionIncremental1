extends Control

@onready var card_offering_manager: CardOfferingManager = $CardOfferingManager

@onready var renderedCardLeft : RenderedCard = $RenderedCardLeft
@onready var renderedCardCenter : RenderedCard = $RenderedCardCenter
@onready var renderedCardRight : RenderedCard = $RenderedCardRight
@onready var end_run_button : Button = $VBoxContainer/EndRunButton
@onready var run_summary : RunSummary = $RunSummary
@onready var runes_chosen_display : OverlappingImageDisplay = $VBoxContainer/HBoxContainer/OverlappingImageDisplay

func _ready() -> void:
	GameplayManager.draws_left = GameplayManager.draws_max
	GameplayManager.capacity_left = GameplayManager.capacity_max
	renderedCardLeft.card_clicked.connect(_on_card_clicked)
	renderedCardCenter.card_clicked.connect(_on_card_clicked)
	renderedCardRight.card_clicked.connect(_on_card_clicked)
	end_run_button.pressed.connect(end_run)
	run_summary.start_new_run.connect(start_run)
	GameplayManager.card_history_update.connect(runes_chosen_display._on_card_history_update)
	start_run()
	

func _on_card_clicked(renderedCard: RenderedCard) -> void:
	# if click is not allowed, make the card do a not allowed thing and return
	if(renderedCard.card_modified.cost > GameplayManager.capacity_left):
		print("not enough capacity for this rune")
		# run animation for not allowed
		return
	if(GameplayManager.draws_left < 1):
		# should never reach this code...
		# if we reach here, end the session
		print("no draws left! ending run")
		end_run()
		return

	# past this point, the click was allowed    

	# apply card effect(s)
	renderedCard.card_modified.applyEffects()
	GameplayManager.draws_left -= 1
	GameplayManager.capacity_left -= renderedCard.card_modified.cost
	StatusManager.tick_statuses()
	
	# play animation for clicking on rune (collect resources/rune, remove other cards)
	# wait for animations to finish (or maybe just a set time?)
	
	add_card_to_history(renderedCard.card_original)


	# check if game should end
	if(GameplayManager.draws_left < 1):
		print("no draws left! ending run")
		end_run()
		return
		


	# else, game continues
	# later, call an animation that does the following:
		# runs the played card animations
		# removes the unplayed cards
		# waits a little bit 
			# based on previous card animation time? 
			# or just a fixed time
		# then, get new cards, and have them appear in animation
	get_and_render_cards()
	pass

func get_and_render_cards() -> void:
	# query the card_offering_manager and get 3 cards from it
	var cards : Array[Card] = card_offering_manager.get_cards(3)
	print(cards)
	# fill the actual rendered card nodes with the correct data
	renderedCardLeft.spawnCard(cards[0], get_modified_card(cards[0]))
	renderedCardCenter.spawnCard(cards[1], get_modified_card(cards[1]))
	renderedCardRight.spawnCard(cards[2], get_modified_card(cards[2]))
	# have the cards play their initial render animations
	

func end_run() -> void:
	# show run summary
	run_summary.show()
	run_summary.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# disable card buttons
	pass

func start_run() -> void:
	run_summary.hide()
	run_summary.mouse_filter = Control.MOUSE_FILTER_STOP

	GameplayManager.gems = 0
	GameplayManager.capacity_left = GameplayManager.capacity_max
	GameplayManager.draws_left = GameplayManager.draws_max

	GameplayManager.card_history = []
	StatusManager.clear_all_statuses()

	card_offering_manager.populate_offerings()
	get_and_render_cards()
	#reenable card buttons

func add_card_to_history(card:Card) -> void:
	GameplayManager.card_history.append(card)
	GameplayManager.card_history_update.emit(GameplayManager.card_history)

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
	return card.image.duplicate()

func get_modified_card_rarity(card: Card) -> Constants.Rarity:
	return card.rarity

func get_modified_card_element(card: Card) -> Constants.Element:
	return card.element

func get_modified_card_effects(card: Card) -> Array[CardEffect]:
	return card.effects.duplicate(true)
