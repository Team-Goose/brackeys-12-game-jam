class_name GameOverMenu extends Control

signal try_again_pressed
signal return_to_title_pressed

func _on_try_again_pressed():
	try_again_pressed.emit()

func _on_return_to_title_pressed():
	return_to_title_pressed.emit()

func _on_quit_to_desktop_pressed():
	get_tree().quit()
