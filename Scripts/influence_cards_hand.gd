extends VBoxContainer

class_name CardsHolder

# Suspicion signals
signal card_add_suspicion(amount:float)
signal card_reduce_suspicion(amount:float)
signal card_suspicion_per_day(days:int, amount:float)

# Blood signals
signal card_add_blood(amount: float)
signal card_reduce_blood(amount: float)
signal card_blood_per_day(days:int, amount:float)

# Money signals
signal card_add_money(amount: int)
signal card_reduce_money(amount: int)
signal card_modifier_money(days:int, modifier:float)

# control signals
signal card_control_select()
signal card_control_random()

# Spread signals
signal card_modifier_spread(days: int, modifier: float)

# Church signals
signal card_spawn_church(amount: int)
signal card_despawn_church(amount: int)

var card_scene = preload("res://Nodes/influence_card.tscn")

var player_cards = []
var bank_cards = []
var graveyard_cards = []

static var can_add_cards:bool = false
static var deck_available:bool = false

# JSON
var deck: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/Cards/deck.json"))
var market: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/Cards/market.json"))
var residential: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/Cards/residential.json"))
var rich: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/Cards/rich.json"))
var slums: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/Cards/slums.json"))

var district_atlas = { 
	"slums": slums, 
	"rich": rich,
	"residential": residential,
	"market": market,
	"deck": deck
	} # supposed to look like string district_name : bool did_discover

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	can_add_cards = player_cards.size() < 3
	deck_available = bank_cards.size() > 0
	for card in player_cards:
		if card.is_card_highlighted and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# selected this card
			graveyard_cards.append(card.card_obj)
			card_effects(card.card_obj)
			player_cards.erase(card)
			card.queue_free()

func add_card_to_hand():
	# if the deck is empty reset it
	if bank_cards.size() <= 0:
		bank_cards = graveyard_cards
		graveyard_cards = []
		bank_cards.shuffle()
	if !can_add_cards:
		return
	var card_ui = card_scene.instantiate()
	card_ui.set_card_data(bank_cards[0])
	$HFlowContainer.add_child(card_ui)
	player_cards.append(card_ui)
	bank_cards.erase(deck[0])

func add_cards_to_bank(district:String):
	var cards_to_add = []
	for district_key in district_atlas.keys():
		if district == district_key:
			cards_to_add = district_atlas[district_key]
	if bank_cards.is_empty():
		bank_cards = cards_to_add
	else:
		bank_cards.append_array(cards_to_add)
	bank_cards.shuffle()

func card_effects(card_data_obj:Dictionary):
	# positive effect label
	if card_data_obj.has("positiveEffect"):
		# types of positive effects
		if card_data_obj.positiveEffect.has("blood"):
			var blood = card_data_obj.positiveEffect.blood
			if blood is float:
				emit_signal("card_add_blood", abs(blood))
			elif blood is Dictionary:
				emit_signal("card_blood_per_day", blood.days, blood.amount)
		if card_data_obj.positiveEffect.has("suspicion"):
			var suspicion = card_data_obj.positiveEffect.suspicion
			if suspicion is float:
				emit_signal("card_reduce_suspicion", suspicion)
			elif suspicion is Dictionary:
				emit_signal("card_suspicion_per_day", suspicion.days, suspicion.amount)
		if card_data_obj.positiveEffect.has("control"):
			var control = card_data_obj.positiveEffect.control
			if control is float:
				if control > 0:
					emit_signal("card_control_select")
				elif control < 0:
					emit_signal("card_control_random")
			#elif control is Dictionary:
				#$BackGround/PositiveLabel.text += "Control +" + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.positiveEffect.has("money"):
			var money = card_data_obj.positiveEffect.money
			if money is float:
				emit_signal("card_add_money", money)
			elif money is Dictionary:
				emit_signal("card_modifier_money", money.days, money.modifier)
		if card_data_obj.positiveEffect.has("spread"):
			var spread = card_data_obj.positiveEffect.spread
			if spread is Dictionary:
				emit_signal("card_modifier_spread", spread.days, spread.modifier)
		if card_data_obj.positiveEffect.has("church"):
			var church = card_data_obj.positiveEffect.church
			if church is float:
				emit_signal("card_despawn_church", church)
	# negative effect label
	if card_data_obj.has("negativeEffect"):
		# types of negative effects
		if card_data_obj.negativeEffect.has("blood"):
			var blood = card_data_obj.negativeEffect.blood
			if blood is float:
				emit_signal("card_reduce_blood", blood)
			elif blood is Dictionary:
				emit_signal("card_blood_per_day", blood.days, blood.amount)
		if card_data_obj.negativeEffect.has("suspicion"):
			var suspicion = card_data_obj.negativeEffect.suspicion
			if suspicion is float:
				emit_signal("card_add_suspicion", suspicion)
			elif suspicion is Dictionary:
				emit_signal("card_suspicion_per_day", suspicion.days, suspicion.amount)
		if card_data_obj.negativeEffect.has("control"):
			var control = card_data_obj.negativeEffect.control
			if control is float:
				if control > 0:
					emit_signal("card_control_select")
				elif control < 0:
					emit_signal("card_control_random")
			#elif control is Dictionary:
				#$BackGround/NegativeLabel.text += "Control " + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.negativeEffect.has("money"):
			var money = card_data_obj.negativeEffect.money
			if money is float:
				emit_signal("card_reduce_money", money)
			elif money is Dictionary:
				emit_signal("card_modifier_money", money.days, money.modifier)
		if card_data_obj.negativeEffect.has("spread"):
			var spread = card_data_obj.negativeEffect.spread
			if spread is Dictionary:
				emit_signal("card_modifier_spread", spread.days, spread.modifier)
		if card_data_obj.negativeEffect.has("church"):
			var church = card_data_obj.negativeEffect.church
			if church is float:
				emit_signal("card_spawn_church", church)

func _on_player_buy_card(_cost):
	add_card_to_hand()
