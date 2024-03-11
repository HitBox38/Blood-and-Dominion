extends Camera2D

var dragging = false
var last_mouse_pos = Vector2.ZERO
@export var camera_move_limit = Vector2(900, 500)

@export var zoom_speed = 0.1

func _input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				dragging = event.pressed
				last_mouse_pos = get_local_mouse_position()
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= Vector2(zoom_speed, zoom_speed)
				zoom = Vector2(max(zoom.x, 0.5), max(zoom.y, 0.5))
			MOUSE_BUTTON_WHEEL_UP:
				zoom += Vector2(zoom_speed, zoom_speed)
				zoom = Vector2(min(zoom.x, 3), min(zoom.y, 3))
	elif event is InputEventMouseMotion:
		if dragging:
			var current_mouse_pos = get_local_mouse_position()
			var deltaMove = last_mouse_pos - current_mouse_pos
			offset += deltaMove
			offset = Vector2(max(offset.x, -camera_move_limit.x), max(offset.y, -camera_move_limit.y))
			offset = Vector2(min(offset.x, camera_move_limit.x), min(offset.y, camera_move_limit.y))
			last_mouse_pos = current_mouse_pos + deltaMove
