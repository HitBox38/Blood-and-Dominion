extends TileMap

@export var infection_max_time = 10.0
@export var infection_spread_min = 0.02
@export var infection_spread_max = 0.15

#@export var infection_suspicion_chance = 0.35
#@export var infection_suspicion_amount = 1.0

@export var church_min_suspicion = 40.0
@export var church_build_max_time = 30
@export var church_build_min_time = 10
@export var max_churches = 10
@export var church_ward_radius = 3

signal cell_suspicious(amount:float)

signal district_discovered(district:String)

var prevTileChanged = Vector2i.MAX
var need_cell_selection = true
var infected_cell_tiles = {}
var infection_time = 0

var modifiers = []

var church_build_time = 0.0
var church_build_wait_time = 25.0
var church_cell_tiles = {} # dictionary is like Vector2i pos : Vector2i[] surrounding_cells

var did_win = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if TimeCycle.is_day:
		spread_infection(delta)
		# if reached certain suspicion then start building churches based on timer
		if Suspicion.player_suspicion >= church_min_suspicion:
			# creating new churches
			church_build_wait_time = church_build_max_time - (Suspicion.player_suspicion / 100) * (church_build_max_time - church_build_min_time)
			church_build_time += delta
			if church_build_time >= church_build_wait_time:
				print_debug(church_build_wait_time)
				church_build_time = 0.0
				build_church()
		print_debug(check_for_win())
		if check_for_win() and !did_win:
			$"../WinStinger".play()
			did_win = true
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
	
	# changing selection cursor
	if need_cell_selection:
		change_selected(Vector2i(2, 0))
	else:
		change_selected(Vector2i(1, 0))

func do_need_selection():
	need_cell_selection = true

func do_select_random():
	var all_cells = get_used_cells_by_id(1, 1, Vector2i.ZERO)
	var rand_cell = all_cells.pick_random()
	while get_cell_atlas_coords(2, rand_cell) != Vector2i(3, 0):
		all_cells.erase(rand_cell)
		rand_cell = all_cells.pick_random()
	set_cell(2, rand_cell, 2, Vector2i.ZERO)
	if(infected_cell_tiles.is_empty()):
		infected_cell_tiles = { rand_cell : 1 }
	else:
		infected_cell_tiles[rand_cell] = 1

func change_selected(selection_atlas):
	var tile = local_to_map(get_local_mouse_position())
	if get_cell_atlas_coords(1, tile) == Vector2i.ZERO:
		set_cell(1, tile, 1, selection_atlas)
	if prevTileChanged != tile && get_cell_atlas_coords(1, tile) == selection_atlas:
		set_cell(1, prevTileChanged, 1, Vector2i.ZERO)
		prevTileChanged = tile

func spread_infection(delta):
	infection_time += delta
	var modified_ifection_max_time = infection_max_time
	for mod in modifiers:
		modified_ifection_max_time = modified_ifection_max_time / mod.modifier
	print_debug(modified_ifection_max_time)
	if infection_time > modified_ifection_max_time:
		infection_time = 0
		for i in range(infected_cell_tiles.size()):
			var tile = infected_cell_tiles.keys()[i]
			var tile_infection = infected_cell_tiles[tile]
			
			if tile_infection >= 0.5:
				# spread to nearest 4 tiles
				var surr_cells = get_surrounding_cells(tile)
				for l in range(surr_cells.size()):
					var cell = surr_cells[l]
					if !is_cell_viable_for_infection(cell):
						continue
					randomize()
					#if randi_range(0, 100) / 100 <= infection_suspicion_chance: # if we didnt reach out of the chances
					#	emit_signal("cell_suspicious", infection_suspicion_amount)
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
	if need_cell_selection && !DailyEvents.is_shown:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var tile = local_to_map(get_local_mouse_position())
				if get_cell_atlas_coords(1, tile) != Vector2i(2, 0):
					return
				var cell_source_id = get_cell_source_id(0, tile)
				
				match(cell_source_id):
					7:
						emit_signal("district_discovered", "slums")
					6:
						emit_signal("district_discovered", "rich")
					5:
						emit_signal("district_discovered", "residential")
				
				set_cell(2, tile, 2, Vector2i.ZERO)
				if(infected_cell_tiles.is_empty()):
					infected_cell_tiles = { tile : 1 }
				else:
					infected_cell_tiles[tile] = 1
				need_cell_selection = false

func build_church():
	var possible_cells = get_used_cells(1)
	# build churches when reached certain suspicion
	var cell_to_build_on = possible_cells.pick_random()
	while infected_cell_tiles.has(cell_to_build_on) or church_cell_tiles.has(cell_to_build_on):
		randomize()
		cell_to_build_on = possible_cells.pick_random()
		if church_cell_tiles.size() >= max_churches:
			break
	if church_cell_tiles.size() < max_churches and is_cell_viable_for_church(cell_to_build_on):
		# build church
		set_cell(2, cell_to_build_on, 4, Vector2i.ZERO)
		var surr_tiles = get_surrounding_cells_by_radius(cell_to_build_on)
		if church_cell_tiles.is_empty():
			church_cell_tiles = { cell_to_build_on : surr_tiles }
		else:
			church_cell_tiles[cell_to_build_on] = surr_tiles
		for surr_cell in surr_tiles:
			set_cell(2, surr_cell, 4, Vector2i(1, 0))

# Function to get the surrounding cells of a given cell
# within a specified radius
func get_surrounding_cells_by_radius(church_cell):
	var surr_cells = []
	for x_offset in range(-church_ward_radius, church_ward_radius + 1):
		for y_offset in range(-church_ward_radius, church_ward_radius + 1):
			# Skip the center cell
			if x_offset == 0 and y_offset == 0:
				continue
			var surr_cell_pos = church_cell + Vector2i(x_offset, y_offset)
			if is_cell_viable_for_church(surr_cell_pos): # Implement this function based on your criteria (e.g., cell exists, is within bounds, etc.)
				surr_cells.append(surr_cell_pos)
	return surr_cells

func is_cell_viable_for_church(cell_pos):
	var is_viable:bool = !(get_cell_source_id(1, cell_pos) == -1 or church_cell_tiles.keys().has(cell_pos))
	return is_viable
	
func is_cell_viable_for_infection(cell_pos):
	var is_viable:bool = !(get_cell_source_id(1, cell_pos) == -1 or church_cell_tiles.values().has(cell_pos))
	return is_viable


func _on_daily_event_news_event_spawn_church(amount: int):
	for i in range(0, amount):
		build_church()


func _on_daily_event_news_event_despawn_church(amount: int):
	if !church_cell_tiles.is_empty():
		for i in range(0, abs(amount)):
			var size = church_cell_tiles.size()
			var random_key = church_cell_tiles.keys()[randi() % size]
			
			set_cell(2, random_key, 2, Vector2i(3, 0))
			
			for surr_cell in church_cell_tiles[random_key]:
				set_cell(2, surr_cell, 2, Vector2i(3, 0))
				
			church_cell_tiles.erase(random_key)

func check_for_win():
	var all_cells = get_used_cells(1)
	return infected_cell_tiles.size() >= all_cells.size() - 1

func _on_time_cycle_day_passed():
	modifiers = modifiers.map(reduce_day_modifier_in_array).filter(remove_day_zero_modifier_in_array)

func reduce_day_modifier_in_array(modifier: Dictionary):
	if modifier.days > 0:
		return { "days": modifier.days - 1, "modifier": modifier.modifier }
	else:
		pass

func remove_day_zero_modifier_in_array(modifier):
	return modifier != null

func _on_daily_event_news_event_change_modifier_spread(days, modifier):
	modifiers.append({ "days": days, "modifier": modifier })
