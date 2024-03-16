extends TextureRect

# Suspicion signals
signal event_add_suspicion(amount:float)
signal event_reduce_suspicion(amount:float)

# Blood signals
signal event_add_blood(amount: float)
signal event_reduce_blood(amount: float)

# Money signals
signal event_add_money(amount: int)
signal event_reduce_money(amount: int)
signal event_change_modifier_money(days: int, modifier: float)

# Spread signals
signal event_change_modifier_spread(days: int, modifier: float)

# Church signals
signal event_spawn_church(amount: int)
signal event_despawn_church(amount: int)

@export var file_path: String = "res://data/DailyEvents/dailyEvents.json"

var json_as_text = FileAccess.get_file_as_string(file_path)
var daily_events: Array = JSON.parse_string(json_as_text)

var was_shown = false

func _input(event):
	if visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			visible = false;

func _process(_delta):
	if !TimeCycle.is_day and !was_shown:
		onPublish()
	elif TimeCycle.is_day:
		was_shown = false

func onPublish():
	if daily_events:
		var daily_event = daily_events.pick_random()
		$TitleLabel.set_text(daily_event.name)
		$SubTitleLabel.set_text(daily_event.flavourText)
		visible = true
		was_shown = true
		startEffect(daily_event.positiveEffect)
		startEffect(daily_event.negativeEffect)

func startEffect(effect: Dictionary):
	if effect.has("suspicion"):
		if effect.suspicion is int or effect.suspicion is float:
			print_debug("suspicion " + str(effect.suspicion))
			if effect.suspicion > 0:
				emit_signal("event_add_suspicion", effect.suspicion)
			elif effect.suspicion < 0:
				emit_signal("event_reduce_suspicion", effect.suspicion)
	elif effect.has("blood"):
		if effect.blood is int or effect.blood is float:
			print_debug("blood " + str(effect.blood))
			if effect.blood > 0:
				emit_signal("event_add_blood", effect.blood)
			elif effect.blood < 0:
				emit_signal("event_reduce_blood", effect.blood)
	elif effect.has("money"):
		if effect.money is float or effect.money is float:
			print_debug("money " + str(effect.money))
			if effect.money > 0:
				emit_signal("event_add_money", int(effect.money))
			elif effect.money < 0:
				emit_signal("event_reduce_money", int(effect.money))
		elif effect.money.days and effect.money.modifier:
			print_debug("money_mod " + str(effect.money.days)+ " " + str(effect.money.modifier))
			emit_signal("event_change_modifier_money", effect.money.days, effect.money.modifier)
	elif effect.has("spread"):
		print_debug("spread " + str(effect.spread.days) + " " + str(effect.spread.modifier))
		emit_signal("event_change_modifier_spread", effect.spread.days, effect.spread.modifier)
	elif effect.has("church"):
		print_debug("church " + str(effect.church))
		if effect.church > 0:
			emit_signal("event_spawn_church", effect.church)
		elif effect.church < 0:
			emit_signal("event_despawn_church", effect.church)
