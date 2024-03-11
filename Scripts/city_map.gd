extends TileMap

@export var infection_max_time = 10.0
@export var infection_spread_min = 0.02
@export var infection_spread_max = 0.15

@export var infection_suspicion_chance = 0.35
@export var infection_suspicion_amount = 1.0

signal cell_suspicious(amount:float)

var prevTileChanged = Vector2i.MAX 
var need_cell_selection = true 
var infected_cell_tiles = {}
var infection_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if TimeCycle.is_day:
		spread_infection(delta)
	# changing selection cursor
	if need_cell_selection:
		change_selected(Vector2i(2, 0))
	else:
		change_selected(Vector2i(1, 0))

func change_selected(selection_atlas):
	var tile = local_to_map(get_local_mouse_position())
	if get_cell_atlas_coords(1, tile) == Vector2i.ZERO:
		set_cell(1, tile, 1, selection_atlas)
	if prevTileChanged != tile && get_cell_atlas_coords(1, tile) == selection_atlas:
		set_cell(1, prevTileChanged, 1, Vector2i.ZERO)
		prevTileChanged = tile

func spread_infection(delta):
	infection_time += delta
	
	if infection_time > infection_max_time:
		infection_time = 0
		for i in range(infected_cell_tiles.size()):
			var tile = infected_cell_tiles.keys()[i]
			var tile_infection = infected_cell_tiles[tile]
			
			if tile_infection >= 0.5:
				# spread to nearest 4 tiles
				var surr_cells = get_surrounding_cells(tile)
				for l in range(surr_cells.size()):
					var cell = surr_cells[l]
					if get_cell_source_id(1, cell) == -1:
						continue
					randomize()
					if randi_range(0, 100) / 100 <= infection_suspicion_chance: # if we didnt reach out of the chances
						emit_signal("cell_suspicious", infection_suspicion_amount)
					var infection_spreading = randf_range(infection_spread_min, infection_spread_max)
					if !infected_cell_tiles.has(cell):
						infected_cell_tiles[cell] = infection_spreading
					elif infected_cell_tiles[cell] != 1:
						infected_cell_tiles[cell] += infection_spreading
			
			# set the tile color to match its corruption
			if tile_infection > 0.8:
				set_cell(2, tile, 2, Vector2i.ZERO)
			elif tile_infection <= 0.8 and tile_infection > 0.5:
				set_cell(2, tile, 2, Vector2i(1, 0))
			elif tile_infection <= 0.5 and tile_infection > 0.25:
				set_cell(2, tile, 2, Vector2i(2, 0))
			else:
				set_cell(2, tile, 2, Vector2i(3, 0))

func _input(event):
	if need_cell_selection:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var tile = local_to_map(get_local_mouse_position())
				if get_cell_atlas_coords(1, tile) != Vector2i(2, 0):
					return
				set_cell(2, tile, 2, Vector2i.ZERO)
				if(infected_cell_tiles.is_empty()):
					infected_cell_tiles = { tile : 1 }
				else:
					infected_cell_tiles[tile] = 1
				need_cell_selection = false
