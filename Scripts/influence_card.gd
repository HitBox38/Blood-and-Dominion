extends Control

signal on_select_card(card)

@export var card_highlight_offset = Vector2(0, 25)

var is_card_highlighted = false
var card_start_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	card_start_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_card_highlighted:
		# highlight card
		position = lerp(position, card_start_position + card_highlight_offset, delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# use card if possible
			print_debug("USED CARD")
	else:
		# un highlight card
		position = lerp(position, card_start_position, delta)

func set_card_data(card_data_obj:Dictionary):
	# title label
	if card_data_obj.has("name"):
		$BackGround/TitleLabel.text = card_data_obj.name
	# positive effect label
	if card_data_obj.has("positiveEffect"):
		# types of positive effects
		if card_data_obj.positiveEffect.has("blood"):
			var blood = card_data_obj.positiveEffect.blood
			if blood is float:
				$BackGround/PositiveLabel.text += str("Blood +" + blood)
			elif blood is Dictionary:
				$BackGround/PositiveLabel.text += str("Blood +" + blood.amount + " for " + blood.days + " days")
		if card_data_obj.positiveEffect.has("suspicion"):
			var suspicion = card_data_obj.positiveEffect.suspicion
			if suspicion is float:
				$BackGround/PositiveLabel.text += str("Suspicion +" + suspicion)
			elif suspicion is Dictionary:
				$BackGround/PositiveLabel.text += str("Suspicion +" + suspicion.amount + " for " + suspicion.days + " days")
		if card_data_obj.positiveEffect.has("control"):
			var control = card_data_obj.positiveEffect.control
			if control is float:
				$BackGround/PositiveLabel.text += str("Control +" + control)
			elif control is Dictionary:
				$BackGround/PositiveLabel.text += str("Control +" + control.amount + " for " + control.days)
		if card_data_obj.positiveEffect.has("money"):
			var money = card_data_obj.positiveEffect.money
			if money is float:
				$BackGround/PositiveLabel.text += str("Money +" + money)
			elif money is Dictionary:
				$BackGround/PositiveLabel.text += str("Money +" + money.amount + " for " + money.days)
		if card_data_obj.positiveEffect.has("spread"):
			var spread = card_data_obj.positiveEffect.spread
			if spread is float:
				$BackGround/PositiveLabel.text += str("Spread +" + spread)
			elif spread is Dictionary:
				$BackGround/PositiveLabel.text += str("Spread +" + spread.amount + " for " + spread.days)
		if card_data_obj.positiveEffect.has("church"):
			var church = card_data_obj.positiveEffect.church
			if church is float:
				$BackGround/PositiveLabel.text += str("Churches " + church)
	# negative effect label
	if card_data_obj.has("negativeEffect"):
		# types of negative effects
		if card_data_obj.negativeEffect.has("blood"):
			var blood = card_data_obj.negativeEffect.blood
			if blood is float:
				$BackGround/NegativeLabel.text += str("Blood " + blood)
			elif blood is Dictionary:
				$BackGround/NegativeLabel.text += str("Blood " + blood.amount + " for " + blood.days + " days")
		if card_data_obj.negativeEffect.has("suspicion"):
			var suspicion = card_data_obj.negativeEffect.suspicion
			if suspicion is float:
				$BackGround/NegativeLabel.text += str("Suspicion " + suspicion)
			elif suspicion is Dictionary:
				$BackGround/NegativeLabel.text += str("Suspicion " + suspicion.amount + " for " + suspicion.days + " days")
		if card_data_obj.negativeEffect.has("control"):
			var control = card_data_obj.negativeEffect.control
			if control is float:
				$BackGround/NegativeLabel.text += str("Control " + control)
			elif control is Dictionary:
				$BackGround/NegativeLabel.text += str("Control " + control.amount + " for " + control.days + " days")
		if card_data_obj.negativeEffect.has("money"):
			var money = card_data_obj.negativeEffect.money
			if money is float:
				$BackGround/NegativeLabel.text += str("Money " + money)
			elif money is Dictionary:
				$BackGround/NegativeLabel.text += str("Money " + money.amount + " for " + money.days + " days")
		if card_data_obj.negativeEffect.has("spread"):
			var spread = card_data_obj.negativeEffect.spread
			if spread is float:
				$BackGround/NegativeLabel.text += str("Spread " + spread)
			elif spread is Dictionary:
				$BackGround/NegativeLabel.text += str("Spread " + spread.amount + " for " + spread.days + " days")
		if card_data_obj.negativeEffect.has("church"):
			var church = card_data_obj.negativeEffect.church
			if church is float:
				$BackGround/NegativeLabel.text += str("Churches +" + church)
	# flavour label
	if card_data_obj.has("flavourText"):
		$BackGround/FlavourLabel.text = card_data_obj.flavourText

func _on_mouse_entered():
	is_card_highlighted = true

func _on_mouse_exited():
	is_card_highlighted = false