class_name RenderedCard
extends PanelContainer

signal card_clicked(renderedCard: RenderedCard)

var card_state : CardState
@export var nameLabel : RichTextLabel
@export var descriptionLabel : RichTextLabel
@export var sprite : TextureRect
@export var costLabel : RichTextLabel
@export var textureButton : TextureButton
@export var audioStreamPlayer: AudioStreamPlayer


## Display Card from beginning (spawn effect).
## [br]Needs both the template card and the one with the currently active numbers
## so that it can determine what effects to apply. 
## [br]Example: Lower cost -> green cost text
func spawnCard(p_card_state: CardState) -> void:
	card_state = p_card_state
	# change all the elements of our display to show the new card's stuff
	nameLabel.text = p_card_state.name
	descriptionLabel.text = p_card_state.description
	sprite.texture = p_card_state.image
	costLabel.text = _get_cost_BBCode()
	textureButton.pressed.connect(_on_pressed)
	sprite.modulate = Constants.element_to_color(p_card_state.element)
	# possibly color the cost or name or something if it can't be played

func _get_cost_BBCode() -> String:
	if card_state.cost < card_state.original_cost:
		return Util.add_BBCode_color(str(card_state.cost), Color.GREEN)
	if card_state.cost > card_state.original_cost:
		return Util.add_BBCode_color(str(card_state.cost), Color.RED)
	return str(card_state.cost)

func _on_pressed():
	card_clicked.emit(self)
	audioStreamPlayer.play()
	pass

# add effect for can't be played

# add displaying End of Life Effect
	# getting used
	# getting not drafted
	# getting consumed/burned
	# should end with the card disappearing completely (hide visuals)
