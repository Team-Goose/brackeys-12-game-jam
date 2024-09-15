extends Control

signal play_pressed
signal leaderboard_pressed
signal options_pressed
signal quit_pressed
signal credits_pressed

func set_username(username: String) -> void:
	%LeaderboardButton.disabled = true if username == '' else false 

func _on_play_pressed() -> void:
	play_pressed.emit()

func _on_leaderboard_pressed() -> void:
	leaderboard_pressed.emit()

func _on_options_pressed() -> void:
	options_pressed.emit()

func _on_quit_pressed() -> void:
	quit_pressed.emit()

func _on_credits_button_pressed() -> void:
	credits_pressed.emit()
# Replace with function body.
