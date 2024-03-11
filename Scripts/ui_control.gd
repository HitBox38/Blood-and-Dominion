extends CanvasLayer

@onready var end_turn_btn = $EndTurnBtn
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if TimeCycle.is_day:
		end_turn_btn.visible = false
	elif TimeCycle.can_end_night:
		end_turn_btn.visible = true
