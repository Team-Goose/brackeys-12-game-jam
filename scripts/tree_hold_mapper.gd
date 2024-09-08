extends Node2D

var rng = RandomNumberGenerator.new()

const BOXES_PER_ROW := 10
const NUM_ROWS := 5

var start_x := 0
var start_y := 0

var weights := PackedFloat32Array([1.0, 1.0, 0.8, 0.8, 0.65, 0.65])
var grid = []

func _ready() -> void:
	start_y = get_viewport_rect().size.y
	var chance_box = preload("res://scenes/chance_box.tscn")
	for i in BOXES_PER_ROW:
		grid.append([])
		for j in NUM_ROWS:
			var strength = rng.rand_weighted(weights)
			var instance: ChanceBox = chance_box.instantiate()
			var rect: Rect2 = instance.get_rect()
			if i == 0 && j == 0:
				start_x += rect.size.x / 2
				start_y -= rect.size.y / 2
			instance.global_position = Vector2(start_x + (i * rect.size.x), start_y - (j * rect.size.y))
			instance.hold_strength = strength
			add_child(instance)
			grid.append(instance)
