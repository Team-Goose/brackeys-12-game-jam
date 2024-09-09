extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_cell_l_clicked(cell: TreeCell):
	# TODO - propagate left click back down to player with proper functionality
	var range = cell.cell_y - %TreeHoldMapper.bottom_cell
	for row in range:
		%TreeHoldMapper.add_tree_row()

func _on_cell_r_clicked(cell: TreeCell):
	# TODO - propagate right click back down to player with proper functionality
	var range = cell.cell_y - %TreeHoldMapper.bottom_cell
	for row in range:
		%TreeHoldMapper.add_tree_row()
