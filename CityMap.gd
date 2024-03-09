extends TileMap

var prevTileChanged = Vector2i.MAX 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_selected()

func change_selected():
	var tile = local_to_map(get_local_mouse_position())
	if get_cell_atlas_coords(1, tile) == Vector2i.ZERO:
		set_cell(1, tile, 1, Vector2i(1, 0))
	if prevTileChanged != tile && get_cell_atlas_coords(1, tile) == Vector2i(1, 0):
		set_cell(1, prevTileChanged, 1, Vector2i.ZERO)
		prevTileChanged = tile
