class_name Wind extends Node2D

var time_start = 0
var wind = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec() / 1000.0
	%RainParticles.intensity_low()
	%SwirlingLeafParticles.intensity_low()

func _physics_process(delta: float) -> void:
	var time_now = Time.get_ticks_msec() / 1000.0
	var time_elapsed = time_now - time_start
	var wind_strength = 10 * sin(time_elapsed / 10.0)
	var wind_direction = Vector2.RIGHT
	var particle_rotation = 90 * sin(time_elapsed / 10.0)
	$ParticlePivot.global_rotation_degrees = particle_rotation
	wind = wind_strength * wind_direction
