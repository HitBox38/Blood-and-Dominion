extends VBoxContainer

var card_scene = preload("res://Nodes/influence_card.tscn")

var player_cards = []
var bank_cards = []
var graveyard_cards = []

# JSON
@export var file_path: String = "res://data/Cards/deck.json"

var json_as_text = FileAccess.get_file_as_string(file_path)
var deck: Array = JSON.parse_string(json_as_text)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_cards_to_bank()
	add_card_to_hand()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for card in player_cards:
		if card.is_card_highlighted and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# selected this card
			graveyard_cards.append(card)
			player_cards.erase(card)
			card.queue_free()
	if deck.size() <= 0:
		deck = graveyard_cards
		graveyard_cards = []
		deck.shuffle()

func add_card_to_hand():
	var card_ui = card_scene.instantiate()
	card_ui.set_card_data(deck[0])
	$HFlowContainer.add_child(card_ui)
	player_cards.append(card_ui)
	deck.erase(deck[0])

func add_cards_to_bank():
	if bank_cards.is_empty():
		bank_cards = deck
		bank_cards.shuffle()
