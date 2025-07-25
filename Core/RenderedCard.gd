class_name RenderedCard
extends PanelContainer

signal card_clicked(renderedCard: RenderedCard)

var card_state : CardState
@export_group("textures")
@export var cost_1_texture : Texture2D
@export var cost_1_texture_filled : Texture2D
@export var cost_5_texture : Texture2D
@export var cost_5_texture_filled : Texture2D
@export var rune_circle_thin : Texture2D
@export var rune_circle_thick : Texture2D
@export var rune_circle_filled: Texture2D

@export_group("internal references")
@export var nameLabel : RichTextLabel
@export var descriptionLabel : RichTextLabel
@export var sprite : TextureRect
@export var costLabel : RichTextLabel
@export var button : Button
@export var audioStreamPlayer: AudioStreamPlayer
@export var rune_circle : TextureRect
@export var cost_0_color : TextureRect
@export var exclude_circles : Array[TextureRect]
@export var cost_circles : Array[TextureRect]



## Display Card from beginning (spawn effect).
## [br]Needs both the template card and the one with the currently active numbers
## so that it can determine what effects to apply. 
## [br]Example: Lower cost -> green cost text
func spawnCard(p_card_state: CardState) -> void:
	card_state = p_card_state
	# change all the elements of our display to show the new card's stuff
	_set_title(p_card_state.name)
	descriptionLabel.text = p_card_state.description
	sprite.texture = p_card_state.image
	#costLabel.text = _get_cost_BBCode()
	_set_card_rarity(card_state.rarity)
	_set_cost_circles()
	button.pressed.connect(_on_pressed)
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

func set_shortcut(shortcut:Shortcut) -> void:
	button.shortcut = shortcut

func _set_title(title:String) -> void:
	nameLabel.text = title
	#nameLabel.text = "[tornado radius=0.3 freq=5.0 connected=0]{%s}[/tornado]" % title

func _set_card_rarity(rarity : Constants.Rarity) -> void:
	match rarity:
		Constants.Rarity.COMMON:
			rune_circle.texture = rune_circle_thin
			rune_circle.modulate = Color.WHITE
		Constants.Rarity.UNCOMMON:
			rune_circle.texture = rune_circle_thick
			rune_circle.modulate = Color.CYAN
		Constants.Rarity.RARE:
			rune_circle.texture = rune_circle_thick
			rune_circle.modulate = Color.GOLD
		Constants.Rarity.WALL:
			rune_circle.texture = rune_circle_filled
			rune_circle.modulate = Color.WHITE

func _set_cost_circles() -> void:
	@warning_ignore("integer_division")
	var num_5_cost :int = card_state.cost / 5
	var num_1_cost :int = card_state.cost - (5*num_5_cost)

	var mod_color : Color = Color.WHITE
	match card_state.rarity:
		Constants.Rarity.COMMON:
			mod_color = Color.WHITE
		Constants.Rarity.UNCOMMON:
			mod_color = Color.CYAN
		Constants.Rarity.RARE:
			mod_color = Color.GOLD
		Constants.Rarity.WALL:
			mod_color = Color.WHITE

	cost_0_color.visible = false

	if card_state.cost < card_state.original_cost:
		mod_color = Color.GREEN
		if card_state.cost == 0:
			cost_0_color.visible = true
			cost_0_color.modulate = Color.GREEN

	if card_state.cost > card_state.original_cost:
		mod_color = Color.RED

	for i in range(16):
		if num_5_cost > 0:
			num_5_cost -= 1
			exclude_circles[i].visible = true
			cost_circles[i].visible = true
			exclude_circles[i].texture = cost_5_texture_filled
			cost_circles[i].texture = cost_5_texture
			cost_circles[i].modulate = mod_color
		elif num_1_cost > 0:
			num_1_cost -= 1
			exclude_circles[i].visible = true
			cost_circles[i].visible = true
			exclude_circles[i].texture = cost_1_texture_filled
			cost_circles[i].texture = cost_1_texture
			cost_circles[i].modulate = mod_color
		else:
			exclude_circles[i].visible = false
			cost_circles[i].visible = false

# add effect for can't be played

# add displaying End of Life Effect
	# getting used
	# getting not drafted
	# getting consumed/burned
	# should end with the card disappearing completely (hide visuals)
