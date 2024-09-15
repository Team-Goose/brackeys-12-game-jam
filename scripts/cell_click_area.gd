extends Area2D

signal area_l_clicked
signal area_r_clicked

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("l_click"):
		area_l_clicked.emit()
	#elif event.is_action_pressed("r_click"):
		#area_r_clicked.emit()
