class_name PauseMenu extends Control

signal unpause_pressed
signal return_to_title_pressed

func _on_unpause_pressed():
	unpause_pressed.emit()

func _on_return_to_title_pressed():
	return_to_title_pressed.emit()

func _on_quit_to_desktop_pressed():
	get_tree().quit()
