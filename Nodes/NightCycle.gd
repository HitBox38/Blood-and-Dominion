extends CanvasModulate

@export var day_time = 30.0
@export var night_time = 45.0

var time:float = 0.0
var is_day:bool = true

var next_color = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	color = lerp(color, next_color, delta)
	if is_day:
		if time >= day_time:
			is_day = false
			next_color = Color.DIM_GRAY
			time = 0

func move_to_day():
	if !is_day and time >= night_time:
		is_day = true
		next_color = Color.WHITE
		time = 0

func _on_button_pressed():
	move_to_day()
