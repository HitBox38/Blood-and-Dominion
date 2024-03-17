extends CanvasModulate

class_name TimeCycle

signal day_passed

@export var day_time: float = 45
#@export var night_time: float = 1

var time:float = 0.0
static var is_day:bool = false
static var can_end_night:bool = false

var next_color = Color.GRAY

func _ready():
	is_day = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	color = lerp(color, next_color, delta)
	if is_day:
		if time >= day_time:
			# day time over move to night
			is_day = false
			next_color = Color.GRAY
			time = 0
	else:
		can_end_night = true
		if $"../MusicDay".playing:
			$"../MusicDay".stop()
		if !$"../MusicNight".playing:
			$"../MusicNight".play()

func move_to_day():
	if can_end_night:
		is_day = true
		can_end_night = false
		next_color = Color.WHITE
		time = 0
		if $"../MusicNight".playing:
			$"../MusicNight".stop()
		if !$"../MusicDay".playing:
			$"../MusicDay".play()
		emit_signal("day_passed")

func _on_end_turn_btn_pressed():
	move_to_day()
