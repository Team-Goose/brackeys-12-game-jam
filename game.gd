extends Node

var tree_hold_mapper_preload = preload("res://scenes/tree_hold_mapper.tscn")
var pause_menu_preload = preload("res://scenes/pause_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") && !%MainMenu.visible:
		if get_tree().paused:
			hide_pause_menu()
		else:
			show_pause_menu()
			

func show_pause_menu() -> void:
	var instance: PauseMenu = pause_menu_preload.instantiate()
	instance.connect("unpause_pressed", hide_pause_menu)
	instance.connect("return_to_title_pressed", return_to_title)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func return_to_title() -> void:
	hide_pause_menu()
	%MainMenu.visible = true
	remove_child($TreeHoldMapper)

func hide_pause_menu() -> void:
	get_tree().paused = false
	$CanvasLayer.remove_child($CanvasLayer/PauseMenu)

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
