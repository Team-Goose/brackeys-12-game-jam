extends Node2D

var rng = RandomNumberGenerator.new()

const BOXES_PER_ROW := 10
const NUM_ROWS := 5

var start_x := 0
var start_y := 0

var weights := PackedFloat32Array([1.0, 0.8, 0.7, 0.5])
var grid = []

func _ready() -> void:
	start_y = get_viewport_rect().size.y
	var chance_box = preload("res://scenes/chance_box.tscn")
	# 3x sequential for loop required to first set base hold strengths, then place good holds, then place decent holds around those
	for i in BOXES_PER_ROW:
		grid.append([])
		for j in NUM_ROWS:
			var strength = rng.rand_weighted(weights)
			var instance: ChanceBox = chance_box.instantiate()
			var rect: Rect2 = instance.get_rect()
			# alter the overall start positions based on the box size when looking at the first box 
			if i == 0 && j == 0:
				start_x += rect.size.x / 2
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
			add_child(instance)
			grid.append(instance)
	
