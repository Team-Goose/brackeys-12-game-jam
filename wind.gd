class_name Wind extends Node

var time_start = 0
var wind = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec()


func _physics_process(delta: float) -> void:
	var time_now = Time.get_ticks_msec()/1000.0
	var time_elapsed = time_now - time_start
	var wind_strength = 10 * sin(time_elapsed/10.0)
	var wind_direction = Vector2.RIGHT
	wind = wind_strength * wind_direction
	print(wind, wind_strength, wind_direction)
	pass
