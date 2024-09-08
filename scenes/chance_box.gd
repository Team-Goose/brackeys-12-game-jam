class_name ChanceBox extends Sprite2D

var hold_strength := 0.0

func _ready() -> void:
	modulate = Color(0, hold_strength / 10.0, 0)
