extends Control

signal on_select_card(card:Dictionary)

@export var card_highlight_offset = Vector2(0, -100)

var is_card_highlighted = false
var card_next_position = null
var card_first_position = null

var card_obj = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if TimeCycle.is_day:
		visible = false
	else:
		visible = true
	if card_next_position != null:
		position = lerp(position, card_next_position, delta * 3)
	if is_card_highlighted:
		# highlight card
		# card selection
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# use card if possible
			emit_signal("on_select_card", card_obj)
			# and remove the card from hand

func set_card_data(card_data_obj:Dictionary):
	card_obj = card_data_obj
	# title label
	if card_data_obj.has("name"):
		$BackGround/TitleLabel.text = card_data_obj.name
	# positive effect label
	if card_data_obj.has("positiveEffect"):
		# types of positive effects
		if card_data_obj.positiveEffect.has("blood"):
			var blood = card_data_obj.positiveEffect.blood
			if blood is float:
				$BackGround/PositiveLabel.text += "Blood +" + str(blood)
			elif blood is Dictionary:
				$BackGround/PositiveLabel.text += "Blood +" + str(blood.amount) + " for " + str(blood.days) + " days"
		if card_data_obj.positiveEffect.has("suspicion"):
			var suspicion = card_data_obj.positiveEffect.suspicion
			if suspicion is float:
				$BackGround/PositiveLabel.text += "Suspicion " + str(suspicion)
			elif suspicion is Dictionary:
				$BackGround/PositiveLabel.text += "Suspicion " + str(suspicion.amount) + " for " + str(suspicion.days) + " days"
		if card_data_obj.positiveEffect.has("control"):
			var control = card_data_obj.positiveEffect.control
			if control is float:
				$BackGround/PositiveLabel.text += "Control +" + str(control)
			#elif control is Dictionary:
				#$BackGround/PositiveLabel.text += "Control +" + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.positiveEffect.has("money"):
			var money = card_data_obj.positiveEffect.money
			if money is float:
				$BackGround/PositiveLabel.text += "Money +" + str(money)
			elif money is Dictionary:
				$BackGround/PositiveLabel.text += "Money *" + str(money.modifier) + " for " + str(money.days) + " days"
		if card_data_obj.positiveEffect.has("spread"):
			var spread = card_data_obj.positiveEffect.spread
			if spread is float:
				$BackGround/PositiveLabel.text += "Spread +" + str(spread)
			elif spread is Dictionary:
				$BackGround/PositiveLabel.text += "Spread *" + str(spread.modifier) + " for " + str(spread.days) + " days"
		if card_data_obj.positiveEffect.has("church"):
			var church = card_data_obj.positiveEffect.church
			if church is float:
				$BackGround/PositiveLabel.text += "Churches " + str(church)
	# negative effect label
	if card_data_obj.has("negativeEffect"):
		# types of negative effects
		if card_data_obj.negativeEffect.has("blood"):
			var blood = card_data_obj.negativeEffect.blood
			if blood is float:
				$BackGround/NegativeLabel.text += "Blood " + str(blood)
			elif blood is Dictionary:
				$BackGround/NegativeLabel.text += "Blood " + str(blood.amount) + " for " + str(blood.days) + " days"
		if card_data_obj.negativeEffect.has("suspicion"):
			var suspicion = card_data_obj.negativeEffect.suspicion
			if suspicion is float:
				$BackGround/NegativeLabel.text += "Suspicion +" + str(suspicion)
			elif suspicion is Dictionary:
				$BackGround/NegativeLabel.text += "Suspicion +" + str(suspicion.amount) + " for " + str(suspicion.days) + " days" 
		if card_data_obj.negativeEffect.has("control"):
			var control = card_data_obj.negativeEffect.control
			if control is float:
				$BackGround/NegativeLabel.text += "Control " + str(control)
			#elif control is Dictionary:
				#$BackGround/NegativeLabel.text += "Control " + str(control.amount) + " for " + str(control.days) + " days"
		if card_data_obj.negativeEffect.has("money"):
			var money = card_data_obj.negativeEffect.money
			if money is float:
				$BackGround/NegativeLabel.text += "Money " + str(money)
			elif money is Dictionary:
				$BackGround/NegativeLabel.text += "Money *" + str(money.modifier) + " for " + str(money.days) + " days"
		if card_data_obj.negativeEffect.has("spread"):
			var spread = card_data_obj.negativeEffect.spread
			if spread is float:
				$BackGround/NegativeLabel.text += "Spread " + str(spread)
			elif spread is Dictionary:
				$BackGround/NegativeLabel.text += "Spread *" + str(spread.modifier) + " for " + str(spread.days) + " days"
		if card_data_obj.negativeEffect.has("church"):
			var church = card_data_obj.negativeEffect.church
			if church is float:
				$BackGround/NegativeLabel.text += "Churches +" + str(church)
	# flavour label
	if card_data_obj.has("flavourText"):
		$BackGround/FlavourLabel.text = card_data_obj.flavourText

func _on_mouse_entered():
	is_card_highlighted = true
	if card_first_position == null:
		card_first_position = position
	card_next_position = card_first_position + card_highlight_offset

func _on_mouse_exited():
	is_card_highlighted = false
	card_next_position = card_first_position
