extends ProgressBar

class_name Suspicion

@export var defeat_suspicion = 100.0

var current_suspicion = 0.0

var modifiers = []

static var player_suspicion = 0.0

func _process(delta):
	if value < current_suspicion:
		value = lerpf(value, current_suspicion, delta)
	if player_suspicion != current_suspicion:
		player_suspicion = current_suspicion

func add_suspicion(amount:float):
	if current_suspicion + amount <= defeat_suspicion:
		current_suspicion += amount
	else:
		# send to defeat
		pass

func reduce_suspicion(amount:float):
	current_suspicion -= abs(amount)
	if current_suspicion <= 0:
		current_suspicion = 0

#func _on_map_cell_suspicious(amount):
#	add_suspicion(amount)

func _on_time_cycle_day_passed():
	modifiers = modifiers.map(reduce_day_modifier_in_array).filter(remove_day_zero_modifier_in_array)
	for mod in modifiers:
		if mod.modifier > 0:
			add_suspicion(mod.modifier)
		elif mod.modifiers < 0:
			reduce_suspicion(mod.modifier)

func _on_card_change_modifier_suspicion(days, modifier):
	modifiers.append({"days": days, "modifier": modifier})

func reduce_day_modifier_in_array(modifier: Dictionary):
	if modifier.days > 0:
		return { "days": modifier.days - 1, "modifier": modifier.modifier }
	else:
		pass

func remove_day_zero_modifier_in_array(modifier):
	return modifier != null
