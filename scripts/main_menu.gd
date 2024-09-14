extends Control

signal play_pressed
signal leaderboard_pressed
signal options_pressed
signal quit_pressed

func _on_play_pressed() -> void:
	play_pressed.emit()

func _on_leaderboard_pressed() -> void:
	leaderboard_pressed.emit()

func _on_options_pressed() -> void:
	options_pressed.emit()

func _on_quit_pressed() -> void:
	quit_pressed.emit()
