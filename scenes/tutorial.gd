extends Control

signal playPressed

func _on_button_pressed():
	playPressed.emit()
	queue_free()
