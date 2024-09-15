extends Control

func _ready() -> void:
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(%LoadingSpinner, 'radial_initial_angle', 360.0, 1.5).as_relative()
	$HTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/top10scores')

func _on_request_completed(result, response_code, headers, body) -> void:
	%LoadingSpinnerBox.visible = false
	var json = JSON.parse_string(body.get_string_from_utf8())
	for obj in json:
		var un_label := Label.new()
		var score_label := Label.new()
		var day_label := Label.new()
		var hbox := HBoxContainer.new()
		var color_rect := ColorRect.new()
		un_label.text = obj['username']
		un_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		un_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		score_label.text = obj['score']
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		day_label.text = obj['day']
		day_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		day_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		color_rect.color = Color.WHITE
		color_rect.custom_minimum_size = Vector2(852, 5)
		hbox.add_child(un_label)
		hbox.add_child(score_label)
		hbox.add_child(day_label)
		%LeaderboardVBox.add_child(hbox)
		%LeaderboardVBox.add_child(color_rect)

func _on_mode_switched(toggled: bool) -> void:
	var num_children = %LeaderboardVBox.get_child_count()
	for i in num_children - 5:
		var child = %LeaderboardVBox.get_child(i + 5)
		child.queue_free()
	$LoadingSpinnerBox.visible = true
	if toggled:
		$HTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/top10scores')
	else:
		$HTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/top10scores')

func _on_return_to_title_button_pressed() -> void:
	queue_free()
