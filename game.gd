extends Node

const GAME_SAVE_LOCATION := 'user://game.save'

var tree_hold_mapper_preload = preload('res://scenes/tree_hold_mapper.tscn')
var pause_menu_preload = preload('res://scenes/pause_menu.tscn')
var game_over_menu_preload = preload('res://scenes/game_over_menu.tscn')
var day_finished_menu_preload = preload('res://scenes/day_finished_menu.tscn')
var game_gui_preload = preload('res://scenes/game_gui.tscn')
var options_menu_preload = preload('res://scenes/options_menu.tscn')
var leaderboard_preload = preload('res://scenes/leaderboard.tscn')
var username_prompt_preload = preload("res://scenes/username_prompt.tscn")
var tutorial_preload = preload("res://scenes/tutorial.tscn")
var credits_preload = preload("res://scenes/Credits.tscn")

var master_bus_index := AudioServer.get_bus_index("Master")
var music_bus_index := AudioServer.get_bus_index("Music")
var sfx_bus_index := AudioServer.get_bus_index("SFX")

var last_highest_point := 0
var last_move_time := Time.get_ticks_msec()
var day := 1
var score := 0
var storm_strength := 0
var username := ''

var high_score := 0

func _ready() -> void:
	# uncomment for debug save overwriting:
	#save_game({
		#'day': 1,
		#'score': 0,
		#'username': ''
	#})
	load_game()
	if username != '':
		%MainMenu.set_username(username)
		$GetHighScoreHTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/myscore/' + username)

func _on_get_high_score_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if 'score' in json:
		high_score = int(json['score'])

func check_save_game() -> void:
	if not FileAccess.file_exists(GAME_SAVE_LOCATION):
		print('SAVE DOES NOT EXIST')
		var new_file := FileAccess.open(GAME_SAVE_LOCATION, FileAccess.WRITE)
		new_file.store_line(JSON.stringify({
			'master_volume': db_to_linear(AudioServer.get_bus_volume_db(master_bus_index)),
			'music_volume': db_to_linear(AudioServer.get_bus_volume_db(music_bus_index)),
			'sfx_volume': db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index)),
			'fullscreen': false,
			'day': day,
			'score': score,
			'username': '',
		}))

func load_game() -> void:
	check_save_game()
	var file := FileAccess.open(GAME_SAVE_LOCATION, FileAccess.READ)
	var json_str := file.get_line()
	var json := JSON.new()
	var parsed := json.parse(json_str)
	if not parsed == OK:
		print("Could not load saved game")
		return
	var data = json.get_data()
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(data['master_volume'])
	)
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(data['music_volume'])
	)
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(data['sfx_volume'])
	)
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if data['fullscreen'] else DisplayServer.WINDOW_MODE_WINDOWED
	)
	day = data['day']
	score = data['score']
	username = data['username']

func save_game(state_change: Variant) -> void:
	check_save_game()
	var read_file := FileAccess.open(GAME_SAVE_LOCATION, FileAccess.READ)
	var json_str := read_file.get_line()
	var json := JSON.new()
	var parsed := json.parse(json_str)
	if not parsed == OK:
		print("Could not load saved game")
		return
	var data = json.get_data()
	for key in state_change:
		data[key] = state_change[key]
	var write_file := FileAccess.open(GAME_SAVE_LOCATION, FileAccess.WRITE)
	write_file.store_line(JSON.stringify(data))

func _process(delta: float) -> void:
	var gui: GameGUI = get_node_or_null(^"CanvasLayer/GameGUI")
	if gui:
		var proportion_time_passed: float = (%DayTimer.wait_time - %DayTimer.time_left) / %DayTimer.wait_time
		gui.set_color(proportion_time_passed)

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
	instance.connect('quit_pressed', quit)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func _on_game_over() -> void:
	var game_over_instance: GameOverMenu = game_over_menu_preload.instantiate()
	game_over_instance.connect('try_again_pressed', reset_play)
	game_over_instance.connect('return_to_title_pressed', return_to_title)
	game_over_instance.connect('quit_pressed', quit)
	game_over_instance.high_score = true if high_score <= score else false
	$CanvasLayer.add_child(game_over_instance)
	if username == '':
		var username_prompt_instance: UsernamePrompt = username_prompt_preload.instantiate()
		username_prompt_instance.connect('username_set', _on_username_set)
		$CanvasLayer.add_child(username_prompt_instance)
	get_tree().paused = true

func _on_username_set(un: String) -> void:
	username = un
	%MainMenu.set_username(un)
	save_game({ 'username': un })

func show_pause_menu() -> void:
	var instance: PauseMenu = pause_menu_preload.instantiate()
	instance.connect('unpause_pressed', hide_pause_menu)
	instance.connect('return_to_title_pressed', return_to_title)
	$CanvasLayer.add_child(instance)
	get_tree().paused = true

func return_to_title(save: bool = false, reset: bool = false) -> void:
	if save:
		day += 1
		save_game({
			'day': day,
			'score': score,
		})
	elif reset:
		set_high_score()
		day = 1
		score = 0
		save_game({
			'day': day,
			'score': score,
		})
	hide_pause_menu()
	$CanvasLayer.remove_child($CanvasLayer/GameOverMenu)
	$CanvasLayer.remove_child($CanvasLayer/DayFinishedMenu)
	$CanvasLayer.remove_child($CanvasLayer/GameGUI)
	%MainMenu.visible = true
	remove_child($TreeHoldMapper)

func quit(save: bool = false, reset: bool = false) -> void:
	if save:
		day += 1
		save_game({
			'day': day,
			'score': score,
		})
	elif reset:
		set_high_score()
		day = 1
		score = 0
		save_game({
			'day': day,
			'score': score,
		})
	get_tree().quit()

func set_high_score() -> void:
	if score > high_score:
		high_score = score
		$SetHighScoreHTTPRequest.request(
			'https://brackeys-12-game-jam-api.fly.dev/scores/newscore/' + username + '/' + str(score) + '/' + str(day),
			[],
			HTTPClient.METHOD_POST,
		)

func hide_pause_menu() -> void:
	get_tree().paused = false
	$CanvasLayer.remove_child($CanvasLayer/PauseMenu)

func _on_cell_l_clicked(cell: TreeCell) -> void:
	## TODO - propagate left click back down to player with proper functionality
	var tree_hold_mapper: TreeHoldMapper = $TreeHoldMapper
	var range = cell.cell_y - tree_hold_mapper.bottom_cell
	for row in range:
		tree_hold_mapper.add_tree_row()
	add_points(cell.cell_y, cell.hold_strength)

func _on_cell_r_clicked(cell: TreeCell) -> void:
	# TODO - propagate right click back down to player with proper functionality
	var tree_hold_mapper: TreeHoldMapper = $TreeHoldMapper
	var range = cell.cell_y - tree_hold_mapper.bottom_cell
	for row in range:
		tree_hold_mapper.add_tree_row()
	add_points(cell.cell_y, cell.hold_strength)

func add_points(y_value: int, hold_strength: int) -> void:
	# only climbing to new heights gets points!
	if y_value > last_highest_point:
		# multiplier is 1 + however many minutes have passed + 10% of storm intensity
		#   + 20% of hold strength + 10% of day number + 20% of distance from last height to new height
		#   ...all multiplied by 0.05 if you waited less than 300ms between moves to discourage spamming
		# timer calc:
		var multiplier: float = ((%DayTimer.wait_time - %DayTimer.time_left) / 60) + 1
		# storm intensity calc:
		multiplier += storm_strength / 10.0
		# hold strength calc:
		multiplier += hold_strength / 5.0
		# day number calc:
		multiplier += (day - 1) / 10.0
		# height difference calc:
		multiplier += (y_value - last_highest_point) / 5.0
		# wait time calc:
		var now = Time.get_ticks_msec()
		if now - last_move_time <= 300:
			multiplier *= 0.05
		score += y_value * multiplier
		last_highest_point = y_value
		last_move_time = now
		$CanvasLayer/GameGUI.set_score(int(score))

func _on_main_menu_play_pressed() -> void:
	var instance = tutorial_preload.instantiate()
	instance.connect("playPressed", _on_tutorial_clear)
	$CanvasLayer.add_child(instance)
	
func _on_tutorial_clear() -> void:
	reset_play()

func _on_main_menu_leaderboard_pressed() -> void:
	var instance = leaderboard_preload.instantiate()
	$CanvasLayer.add_child(instance)

func _on_main_menu_options_pressed() -> void:
	var instance = options_menu_preload.instantiate()
	instance.connect('save_options', save_game)
	$CanvasLayer.add_child(instance)
	
func _on_main_menu_credits_pressed() -> void:
	var instance = credits_preload.instantiate()
	$CanvasLayer.add_child(instance)

func _on_main_menu_quit_pressed() -> void:
	get_tree().quit()

func reset_play(reset_score: bool = false, increase_day: bool = false) -> void:
	get_tree().paused = false
	last_highest_point = 0
	var curr_game = $TreeHoldMapper
	if curr_game != null:
		remove_child($TreeHoldMapper)
		$CanvasLayer.remove_child($CanvasLayer/GameGUI)
	var game_over = $CanvasLayer/GameOverMenu
	if game_over != null:
		$CanvasLayer.remove_child(game_over)
	var day_finished = $CanvasLayer/DayFinishedMenu
	if day_finished != null:
		$CanvasLayer.remove_child(day_finished)
	%MainMenu.visible = false
	var thm_instance: TreeHoldMapper = tree_hold_mapper_preload.instantiate()
	thm_instance.connect('cell_l_clicked', _on_cell_l_clicked)
	thm_instance.connect('cell_r_clicked', _on_cell_r_clicked)
	thm_instance.get_node('Player').connect('storm_strength_changed', _on_storm_strength_changed)
	thm_instance.get_node('Player').connect('game_over', _on_game_over)
	thm_instance.set_storm_day(day)
	add_child(thm_instance)
	var gui_instance: GameGUI = game_gui_preload.instantiate()
	$CanvasLayer.add_child(gui_instance)
	if reset_score:
		set_high_score()
		score = 0
		day = 1
	elif increase_day:
		day += 1
	$CanvasLayer/GameGUI.set_score(int(score))
	$CanvasLayer/GameGUI.set_day(day)
	%DayTimer.start()

func _on_storm_strength_changed(val: int) -> void:
	storm_strength = val
	if val >= 8:
		$CanvasLayer/GameGUI.show_warning()
	else:
		$CanvasLayer/GameGUI.hide_warning()

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
