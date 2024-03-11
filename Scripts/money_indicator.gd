extends Label

@export var start_money = 10
@export var seconds_to_money = 1.5

var current_money:int = 0
var money_to_add = 1
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_money = start_money

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(current_money) + "$"
	if TimeCycle.is_day:
		add_money_timed(delta)

func add_money_timed(delta):
	time += delta
	
	if time >= seconds_to_money: # then add money
		current_money += money_to_add
		time = 0

func add_money(amount:int):
	current_money += amount
	if current_money >= 9223372036854775807:
		current_money = 10

func subtract_money(amount:int):
	current_money -= amount
	if current_money <= 0:
		current_money = 0
