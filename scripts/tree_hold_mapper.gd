class_name TreeHoldMapper extends Node2D

var rng := RandomNumberGenerator.new()

const BOXES_PER_ROW := 12
const NUM_ROWS := 5
const GOOD_HOLD_THRESHOLD := 0.1
const HOW_GOOD_THRESHOLD := 0.4

# effectively a const but const doesn't get along with PackedFloat32Array for some reason
var weights := PackedFloat32Array([1.0, 0.8, 0.7, 0.5])

var tree_cell = preload("res://scenes/tree_cell.tscn")
var atlas_texture = load("res://assets/tree_sprite_sheet.png")
var start_x := 0
var start_y := 0
var grid := []
var next_row_to_delete := -1
var bottom_cell := 0

func _ready() -> void:
	var instance: TreeCell = tree_cell.instantiate()
	var rect: Rect2 = instance.get_rect()
	var vp_rect = get_viewport_rect().size
	start_x = (vp_rect.x / 2) - (rect.size.x * BOXES_PER_ROW / 2)
	start_x += rect.size.x / 2
	start_y = vp_rect.y
	start_y -= rect.size.y / 2
	$TreeCam.global_position = Vector2(vp_rect.x / 2, vp_rect.y / 2)
	for i in BOXES_PER_ROW:
		grid.append([])
		var cells_in_height := 0
		while cells_in_height * rect.size.y <= vp_rect.y:
			add_tree_cell(i, cells_in_height)
			cells_in_height += 1
	# only delete cells that are far enough off the screen
	#   for the camera not to clip them as it's moving:
	next_row_to_delete = grid[0].size() * -2

# debug function for generating new rows of the tree on direction press:
#func _input(event: InputEvent) -> void:
	#var instance: TreeCell = tree_cell.instantiate()
	#var rect: Rect2 = instance.get_rect()
	#if event.is_action_pressed("up"):
		#add_tree_row()
	#if event.is_action_pressed("down"):
		#$TreeCam.global_position.y += rect.size.y

func add_tree_row() -> void:
	var instance: TreeCell = tree_cell.instantiate()
	var rect: Rect2 = instance.get_rect()
	for i in grid.size():
		add_tree_cell(i, grid[i].size())
		if next_row_to_delete >= 0:
			grid[i][next_row_to_delete].queue_free()
			grid[i][next_row_to_delete] = null
	$TreeCam.global_position.y -= rect.size.y
	next_row_to_delete += 1
	bottom_cell += 1

func add_tree_cell(i: int, j: int) -> void:
	var instance: TreeCell = tree_cell.instantiate()
	var rect: Rect2 = instance.get_rect()
	var strength = rng.rand_weighted(weights)
	instance.global_position = Vector2(
		start_x + (i * rect.size.x),
		start_y - (j * rect.size.y)
	)
	var good_hold_chance = randf()
	if good_hold_chance <= GOOD_HOLD_THRESHOLD:
		var how_good_chance = randf()
		if how_good_chance <= HOW_GOOD_THRESHOLD:
			instance.hold_strength = instance.GREAT_HOLD_THRESHOLD
		else:
			instance.hold_strength = instance.DECENT_HOLD_THRESHOLD
	else:
		instance.hold_strength = strength
	if i == 0:
		instance.set_side_sprite(atlas_texture, "left")
	elif i == BOXES_PER_ROW - 1:
		instance.set_side_sprite(atlas_texture, "right")
	else:
		instance.set_atlas_regions(atlas_texture)
	instance.cell_l_clicked.connect(func(cell: TreeCell):
		cell_l_clicked.emit(cell)
	)
	instance.cell_r_clicked.connect(func(cell: TreeCell):
		cell_r_clicked.emit(cell)
	)
	instance.cell_x = i
	instance.cell_y = j
	add_child(instance)
	grid[i].append(instance)
