class_name DayFinishedMenu extends Control

signal continue_pressed(reset: bool, increase_day: bool)
signal return_to_title_pressed(save: bool)
signal quit_pressed(save: bool)

func _on_continue_pressed():
	continue_pressed.emit(false, true)

func _on_return_to_title_pressed():
	return_to_title_pressed.emit(true)

func _on_quit_to_desktop_pressed():
	quit_pressed.emit(true)
