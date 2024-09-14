extends Control

func _ready() -> void:
	var tween: Tween = get_tree().create_tween().set_loops()
	tween.tween_property(%LoadingSpinner, 'radial_initial_angle', 360.0, 1.5).as_relative()
	$HTTPRequest.request('https://brackeys-12-game-jam-api.fly.dev/scores/top10scores')

func _on_request_completed(result, response_code, headers, body) -> void:
	var num_children = %LeaderboardVBox.get_child_count()
	for i in num_children - 5:
		var child = %LeaderboardVBox.get_child(i + 5)
		%LeaderboardVBox.remove_child(child)
	%LoadingSpinnerBox.visible = false
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
