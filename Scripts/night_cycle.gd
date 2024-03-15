extends CanvasModulate

class_name TimeCycle

@export var day_time = 30.0
@export var night_time = 45.0

var time:float = 0.0
static var is_day:bool = false
static var can_end_night:bool = false

var next_color = Color.DIM_GRAY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	color = lerp(color, next_color, delta)
	if is_day:
		if time >= day_time:
			# day time over move to night
			is_day = false
			next_color = Color.DIM_GRAY
			time = 0
	else:
		if time >= night_time:
			can_end_night = true

func move_to_day():
	if can_end_night:
		is_day = true
		can_end_night = false
		next_color = Color.WHITE
		time = 0

func _on_end_turn_btn_pressed():
	move_to_day()
