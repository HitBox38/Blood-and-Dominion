extends ProgressBar

@export var defeat_suspicion = 100.0

var current_suspicion = 0.0

func _process(delta):
	if value < current_suspicion:
		value = lerpf(value, current_suspicion, delta)

func add_suspicion(amount:float):
	current_suspicion += amount
	if current_suspicion >= defeat_suspicion:
		# send to defeat
		pass

func reduce_suspicion(amount:float):
	current_suspicion -= amount
	if current_suspicion <= 0:
		current_suspicion = 0

func _on_map_cell_suspicious(amount):
	add_suspicion(amount)
