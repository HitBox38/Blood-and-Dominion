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

# Control signals
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
@export var deck: Array = [{
	"name": "Feed",
	"positiveEffect": {
	  "blood": 10
	},
	"negativeEffect": {
	  "suspicion": 10
	},
	"flavourText": "“Is the wolf evil for killing the rabbit when the opportunity presents itself? I think not!”",
	"source": "deck"
  },{
	"name": "Feed",
	"positiveEffect": {
	  "blood": 10
	},
	"negativeEffect": {
	  "suspicion": 10
	},
	"flavourText": "“Is the wolf evil for killing the rabbit when the opportunity presents itself? I think not!”",
	"source": "deck"
  },{
	"name": "Feed",
	"positiveEffect": {
	  "blood": 10
	},
	"negativeEffect": {
	  "suspicion": 10
	},
	"flavourText": "“Is the wolf evil for killing the rabbit when the opportunity presents itself? I think not!”",
	"source": "deck"
  },
  {
	"name": "Elevate a believer",
	"positiveEffect": {
	  "spread": {
		"days": 3,
		"modifier": 1.5
	  }
	},
	"negativeEffect": {
	  "blood": -10
	},
	"flavourText": "“I give you my blood to elevate a worthy man to more than just a man. Lead them!”",
	"source": "deck"
  },
  {
	"name": "Ghoul Beasts",
	"positiveEffect": {
	  "control": 1
	},
	"negativeEffect": {
	  "blood": -10
	},
	"flavourText": "“With a bit of blood any animal will obey and spread my influence.”",
	"source": "deck"
  }]
@export var market: Array = [{
	"name": "Panacea distribution",
	"positiveEffect": {
	  "money": 20
	},
	"negativeEffect": {
	  "blood": -20
	},
	"flavourText": "“What if we actually do what we claim to do”",
	"source": "market"
  },
  {
	"name": "Blood donations",
	"positiveEffect": {
	  "blood": 10
	},
	"negativeEffect": {
	  "money": -15
	},
	"flavourText": "“We can alway pay them for it”",
	"source": "market"
  },
  {
	"name": "Healing centre",
	"positiveEffect": {
	  "money": {
		"days": 3,
		"modifier": 1.5
	  }
	},
	"negativeEffect": {
	  "suspicion": 10,
	  "blood": -10
	},
	"flavourText": "“For a small payment we can heal any injury”",
	"source": "market"
  }]
@export var residential: Array = [{
	"name": "Blend in",
	"positiveEffect": {
	  "suspicion": -10
	},
	"negativeEffect": {
	  "spread": {
		"days": 3,
		"modifier": 0.25
	  }
	},
	"flavourText": "“No one suspects a family with kids”",
	"source": "residential"
  },
  {
	"name": "Defy the faith",
	"positiveEffect": {
	  "church": -1
	},
	"negativeEffect": {
	  "suspicion": 10,
	  "blood": -10
	},
	"flavourText": "“Join me and break the chains of your would be masters”",
	"source": "residential"
  },
  {
	"name": "Business investment",
	"positiveEffect": {
	  "blood": {
		"days": 3,
		"amount": 5
	  }
	},
	"negativeEffect": {
	  "money": {
		"days": 3,
		"modifier": 0.25
	  }
	},
	"flavourText": "“We can loan them the money but the interest will be paid in blood”",
	"source": "residential"
  }]
@export var rich: Array = [{
	"name": "Corrupt statesmen",
	"positiveEffect": {
	  "church": -1
	},
	"negativeEffect": {
	  "blood": -10,
	  "money": -15
	},
	"flavourText": "“Its funny how easy they turn on each other when you pay them to do so”",
	"source": "rich"
  },
  {
	"name": "News campaign",
	"positiveEffect": {
	  "suspicion": -10
	},
	"negativeEffect": {
	  "blood": -10,
	  "money": -15
	},
	"flavourText": "“Write it down. I want it to be on the front page.”",
	"source": "rich"
  },
  {
	"name": "Taxation",
	"positiveEffect": {
	  "money": 20
	},
	"negativeEffect": {
	  "suspicion": 10,
	  "blood": -10
	},
	"flavourText": "“The best kind of theft. The legal kind”",
	"source": "rich"
  }]
@export var slums: Array = [{
	"name": "Scare the opposition",
	"positiveEffect": {
	  "suspicion": -10
	},
	"negativeEffect": {
	  "blood": -20
	},
	"flavourText": "“Go on… tell them. Who will ever believe you?”",
	"source": "slums"
  },
  {
	"name": "Cull the unworthy",
	"positiveEffect": {
	  "blood": 20
	},
	"negativeEffect": {
	  "control": -1,
	  "suspicion": 10
	},
	"flavourText": "“Those unworthy of the blood will be drained of theirs”",
	"source": "slums"
  },
  {
	"name": "Speakeasy",
	"positiveEffect": {
	  "suspicion": {
		"days": 3,
		"amount": -10
	  }
	},
	"negativeEffect": {
	  "blood": {
		"days": 3,
		"amount": -10
	  }
	},
	"flavourText": "“Make it a really nice place. Entry with Invitations only”",
	"source": "slums"
  }]

var district_atlas = { 
	"slums": slums, 
	"rich": rich,
	"residential": residential,
	"market": market,
	"deck": deck
	} # supposed to look like string district_name : bool did_discover

func _ready():
	add_cards_to_bank("deck")

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
			if blood is float or blood is int:
				emit_signal("card_add_blood", abs(blood))
			elif blood is Dictionary:
				emit_signal("card_blood_per_day", blood.days, blood.amount)
		if card_data_obj.positiveEffect.has("suspicion"):
			var suspicion = card_data_obj.positiveEffect.suspicion
			print_debug(suspicion)
			if suspicion is float or suspicion is int:
				emit_signal("card_reduce_suspicion", suspicion)
			elif suspicion is Dictionary:
				emit_signal("card_suspicion_per_day", suspicion.days, suspicion.amount)
		if card_data_obj.positiveEffect.has("control"):
			var control = card_data_obj.positiveEffect.control
			if control is float or control is int:
				if control > 0:
					emit_signal("card_control_select")
				elif control < 0:
					emit_signal("card_control_random")
			#elif control is Dictionary:
				#$BackGround/PositiveLabel.text += "Control +" + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.positiveEffect.has("money"):
			var money = card_data_obj.positiveEffect.money
			if money is float or money is int:
				emit_signal("card_add_money", money)
			elif money is Dictionary:
				emit_signal("card_modifier_money", money.days, money.modifier)
		if card_data_obj.positiveEffect.has("spread"):
			var spread = card_data_obj.positiveEffect.spread
			if spread is Dictionary:
				emit_signal("card_modifier_spread", spread.days, spread.modifier)
		if card_data_obj.positiveEffect.has("church"):
			var church = card_data_obj.positiveEffect.church
			if church is float or church is int:
				emit_signal("card_despawn_church", church)
	# negative effect label
	if card_data_obj.has("negativeEffect"):
		# types of negative effects
		if card_data_obj.negativeEffect.has("blood"):
			var blood = card_data_obj.negativeEffect.blood
			if blood is float or blood is int:
				emit_signal("card_reduce_blood", blood)
			elif blood is Dictionary:
				emit_signal("card_blood_per_day", blood.days, blood.amount)
		if card_data_obj.negativeEffect.has("suspicion"):
			var suspicion = card_data_obj.negativeEffect.suspicion
			if suspicion is float or suspicion is int:
				emit_signal("card_add_suspicion", suspicion)
			elif suspicion is Dictionary:
				emit_signal("card_suspicion_per_day", suspicion.days, suspicion.amount)
		if card_data_obj.negativeEffect.has("control"):
			var control = card_data_obj.negativeEffect.control
			if control is float or control is int:
				if control > 0:
					emit_signal("card_control_select")
				elif control < 0:
					emit_signal("card_control_random")
			#elif control is Dictionary:
				#$BackGround/NegativeLabel.text += "Control " + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.negativeEffect.has("money"):
			var money = card_data_obj.negativeEffect.money
			if money is float or money is int:
				emit_signal("card_reduce_money", money)
			elif money is Dictionary:
				emit_signal("card_modifier_money", money.days, money.modifier)
		if card_data_obj.negativeEffect.has("spread"):
			var spread = card_data_obj.negativeEffect.spread
			if spread is Dictionary:
				emit_signal("card_modifier_spread", spread.days, spread.modifier)
		if card_data_obj.negativeEffect.has("church"):
			var church = card_data_obj.negativeEffect.church
			if church is float or church is int:
				emit_signal("card_spawn_church", church)

func _on_player_buy_card(_cost):
	add_card_to_hand()
