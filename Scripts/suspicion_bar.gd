extends ProgressBar

class_name Suspicion

@export var defeat_suspicion = 100.0

var current_suspicion = 0.0

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

