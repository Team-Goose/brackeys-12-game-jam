extends Node

var tree_hold_mapper_preload = preload('res://scenes/tree_hold_mapper.tscn')
var pause_menu_preload = preload('res://scenes/pause_menu.tscn')
var game_over_menu_preload = preload('res://scenes/game_over_menu.tscn')
var day_finished_menu_preload = preload('res://scenes/day_finished_menu.tscn')

var score := 0
var storm_strength := 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('esc') && !%MainMenu.visible:
		if get_tree().paused:
			hide_pause_menu()
		else:
			show_pause_menu()

func _on_day_finished() -> void:
	var instance: DayFinishedMenu = day_finished_menu_preload.instantiate()
	instance.connect('continue_pressed', reset_play)
	instance.connect('return_to_title_pressed', return_to_title)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func _on_game_over() -> void:
	var instance: GameOverMenu = game_over_menu_preload.instantiate()
	instance.connect('try_again_pressed', reset_play)
	instance.connect('return_to_title_pressed', return_to_title)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func show_pause_menu() -> void:
	var instance: PauseMenu = pause_menu_preload.instantiate()
	instance.connect('unpause_pressed', hide_pause_menu)
	instance.connect('return_to_title_pressed', return_to_title)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func return_to_title() -> void:
	hide_pause_menu()
	$CanvasLayer.remove_child($CanvasLayer/GameOverMenu)
	$CanvasLayer.remove_child($CanvasLayer/DayFinishedMenu)
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
	var tree_hold_mapper: TreeHoldMapper = $TreeHoldMapper
	var range = cell.cell_y - tree_hold_mapper.bottom_cell
	for row in range:
		tree_hold_mapper.add_tree_row()

func _on_main_menu_play_pressed() -> void:
	reset_play()

func _on_main_menu_options_pressed() -> void:
	print("options pressed") # TODO

func _on_main_menu_quit_pressed() -> void:
	get_tree().quit()

func reset_play() -> void:
	get_tree().paused = false
	var curr_game = $TreeHoldMapper
	if curr_game != null:
		remove_child($TreeHoldMapper)
	var game_over = $CanvasLayer/GameOverMenu
	if game_over != null:
		$CanvasLayer.remove_child(game_over)
	var day_finished = $CanvasLayer/DayFinishedMenu
	if day_finished != null:
		$CanvasLayer.remove_child(day_finished)
	%MainMenu.visible = false
	var instance: TreeHoldMapper = tree_hold_mapper_preload.instantiate()
	instance.connect('cell_l_clicked', _on_cell_l_clicked)
	instance.connect('cell_r_clicked', _on_cell_r_clicked)
	instance.get_node('Player').connect('storm_strength_changed', _on_storm_strength_changed)
	add_child(instance)

func _on_storm_strength_changed(val: int) -> void:
	storm_strength = val

func _on_tambourine_finished() -> void:
	%Tambourine.play()
	if %MainMenu.visible:
		%Marimba1.play()
	else:
		if storm_strength > 0 && storm_strength <= 6:
			%Marimba1.play()
		if storm_strength > 2:
			%Contrabass.play()
		if storm_strength > 4:
			%Ukulele.play()
		if storm_strength > 6:
			%Marimba2.play()
		if storm_strength > 8:
			%Trumpet.play()
