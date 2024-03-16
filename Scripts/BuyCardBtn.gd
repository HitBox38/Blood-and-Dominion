extends Button

@export var card_cost = 10

signal player_bought_card(cost:int)

var can_buy_card = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	can_buy_card = Wallet.money >= card_cost and CardsHolder.can_add_cards and !TimeCycle.is_day
	disabled = !can_buy_card
	visible = !TimeCycle.is_day
	
func _pressed():
	if can_buy_card:
		emit_signal("player_bought_card", card_cost)
