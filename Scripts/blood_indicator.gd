extends Label

@export var start_blood = 5.7
@export var blood_to_lose = 0.7
@export var blood_to_add = 0.5
@export var seconds_to_blood = 1.5

var current_blood = 1.0

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_blood = start_blood


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(current_blood) + "lt."
	if TimeCycle.is_day:
		add_blood_timed(delta)


func add_blood_timed(delta):
	time += delta
	
	if time >= seconds_to_blood: # then lose blood
		decrease_blood(blood_to_lose)
		time = 0

func decrease_blood(amount: float):
	current_blood -= amount
	if current_blood <= 0:
		current_blood = 0

func increase_blood(amount: float):
	current_blood += amount
	if current_blood >= 1.79769e308:
		current_blood = 10
