extends Node2D

var rng = RandomNumberGenerator.new()

const BOXES_PER_ROW := 12
const NUM_ROWS := 5

var start_x := 0
var start_y := 0

var weights := PackedFloat32Array([1.0, 0.8, 0.7, 0.5])
var grid = []

func _ready() -> void:
	var chance_box = preload("res://scenes/chance_box.tscn")
	var atlas_texture = load("res://assets/tree_sprite_sheet.png")
	for i in BOXES_PER_ROW:
		grid.append([])
		for j in NUM_ROWS:
			var strength = rng.rand_weighted(weights)
			var instance: ChanceBox = chance_box.instantiate()
			var rect: Rect2 = instance.get_rect()
			# alter the overall start positions based on the box size when looking at the first box 
			if i == 0 && j == 0:
				var vp_rect = get_viewport_rect().size
				start_x = (vp_rect.x / 2) - (rect.size.x * BOXES_PER_ROW / 2)
				start_x += rect.size.x / 2
				start_y = vp_rect.y
				start_y -= rect.size.y / 2
			instance.global_position = Vector2(start_x + (i * rect.size.x), start_y - (j * rect.size.y))
			var good_hold_chance = randf()
			if good_hold_chance >= 0.9:
				var how_good_chance = randf()
				if how_good_chance >= 0.6:
					instance.hold_strength = 9
				else:
					instance.hold_strength = 7
			else:
				instance.hold_strength = strength
			instance.set_atlas_regions(atlas_texture)
			add_child(instance)
			grid.append(instance)
	
