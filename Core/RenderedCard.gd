class_name RenderedCard
extends Control

signal card_clicked(renderedCard: RenderedCard)

var card_original : Card
var card_modified : Card
@onready var nameLabel : RichTextLabel = $NameLabel
@onready var descriptionLabel : RichTextLabel = $DescriptionLabel
@onready var sprite : TextureRect = $TextureRect
@onready var costLabel : RichTextLabel = $CostLabel
@onready var textureButton : TextureButton = $TextureButton
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer


# Display Card from beginning (spawn effect)
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

# effect for can't be played

# generate the text
	# possible feature: color parts of the description 
	# 	- red if cost is too high
	# 	- red if a conditional won't activate
	# 	- yellow if a conditional WILL activate
	# 	- green if a number is increased
	# 	- red if a number is decreased

# display End of Life Effect
	# display getting used
	# display getting not drafted
	# display getting consumed/burned
	# should end with the card disappearing completely (hide visuals)
