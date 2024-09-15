class_name GameOverMenu extends Control

signal try_again_pressed(reset_score: bool)
signal return_to_title_pressed(save: bool, reset: bool)
signal quit_pressed(save: bool, reset: bool)

var high_score := false

func _ready() -> void:
	if high_score:
		%HighScoreLabel.visible = true

func _on_try_again_pressed():
	try_again_pressed.emit(true)

func _on_return_to_title_pressed():
	return_to_title_pressed.emit(false, true)

func _on_quit_to_desktop_pressed():
	quit_pressed.emit(false, true)
