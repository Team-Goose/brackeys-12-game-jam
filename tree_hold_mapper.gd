extends Node2D

const BOXES_PER_ROW := 10
const NUM_ROWS := 5

var grid = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in BOXES_PER_ROW:
		grid.append([])
		for j in NUM_ROWS:
			grid[i].append(randi_range(0, 10))
	print(grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
