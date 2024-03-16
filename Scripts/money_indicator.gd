extends Label

@export var start_money = 10
@export var seconds_to_money = 1.5
@export var money_to_add = 1

var current_money:int = 0
var time = 0
var modifiers = []

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
		var money_after_modifier: int = money_to_add
		for mod in modifiers:
			money_after_modifier *= mod.modifier
		add_money(money_after_modifier)
		time = 0

func add_money(amount:int):
	current_money += amount
	if current_money >= 9223372036854775807:
		current_money = 10

func subtract_money(amount:int):
	current_money -= amount
	if current_money <= 0:
		current_money = 0

func _on_daily_event_news_event_change_modifier_money(days, modifier):
	modifiers.append({"days": days, "modifier": modifier})

func _on_time_cycle_day_passed():
	modifiers = modifiers.map(reduce_day_modifier_in_array).filter(remove_day_zero_modifier_in_array)

func reduce_day_modifier_in_array(modifier: Dictionary):
	if modifier.days > 0:
		return { "days": modifier.days - 1, "modifier": modifier.modifier}
	else:
		pass

func remove_day_zero_modifier_in_array(modifier):
	return modifier != null
