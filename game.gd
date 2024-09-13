extends Node

var tree_hold_mapper_preload = preload("res://scenes/tree_hold_mapper.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		#%TreeHoldMapper.visible = false
		#%MainMenu.visible = true
		print("add a pause screen pls")
		get_tree().quit()

func _on_cell_l_clicked(cell: TreeCell):
	## TODO - propagate left click back down to player with proper functionality
	var tree_hold_mapper: TreeHoldMapper = $TreeHoldMapper
	var range = cell.cell_y - tree_hold_mapper.bottom_cell
	for row in range:
		tree_hold_mapper.add_tree_row()

func _on_cell_r_clicked(cell: TreeCell):
	# TODO - propagate right click back down to player with proper functionality
	print("zxcv")
	var tree_hold_mapper: TreeHoldMapper = $TreeHoldMapper
	var range = cell.cell_y - tree_hold_mapper.bottom_cell
	for row in range:
		tree_hold_mapper.add_tree_row()

func _on_main_menu_play_pressed() -> void:
	%MainMenu.visible = false
	var instance: TreeHoldMapper = tree_hold_mapper_preload.instantiate()
	instance.connect("cell_l_clicked", _on_cell_l_clicked)
	instance.connect("cell_r_clicked", _on_cell_r_clicked)
	add_child(instance)

func _on_main_menu_options_pressed() -> void:
	print("options pressed") # TODO

func _on_main_menu_quit_pressed() -> void:
	get_tree().quit()
