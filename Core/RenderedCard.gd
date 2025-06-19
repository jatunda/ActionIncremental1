class_name RenderedCard
extends PanelContainer

signal card_clicked(renderedCard: RenderedCard)

var card_original : Card
var card_modified : Card
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
func spawnCard(p_card_original: Card, p_card_modified) -> void:
	card_original = p_card_original
	card_modified = p_card_modified
	# change all the elements of our display to show the new card's stuff
	nameLabel.text = card_modified.name
	descriptionLabel.text = card_modified.description
	sprite.texture = card_modified.image
	costLabel.text = _get_cost_BBCode()
	textureButton.pressed.connect(_on_pressed)
	sprite.modulate = Constants.element_to_color(card_modified.element)
	# possibly color the cost or name or something if it can't be played

func _get_cost_BBCode() -> String:
	if card_modified.cost < card_original.cost:
		return Util.add_BBCode_color(str(card_modified.cost), Color.GREEN)
	if card_modified.cost > card_original.cost:
		return Util.add_BBCode_color(str(card_modified.cost), Color.RED)
	return str(card_modified.cost)

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
