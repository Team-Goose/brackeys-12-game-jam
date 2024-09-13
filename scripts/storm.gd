class_name Storm extends Node2D

signal storm_strength(val: int)

var time_start = 0
var wind = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec() / 1000.0
	%RainParticles.intensity_off()
	%SwirlingLeafParticles.intensity_off()

func _physics_process(delta: float) -> void:
	var time_now = Time.get_ticks_msec() / 1000.0
	var time_elapsed = time_now - time_start
	var wind_strength = (5 * sin(time_elapsed / 60.0)) + 5 # range from 0 to 10 on a sine curve
	var wind_direction = Vector2.RIGHT
	var particle_pivot_rotation = 90 * sin(time_elapsed / 10.0) # range from -90 to 90 on a sine curve
	%ParticlePivot.global_rotation_degrees = particle_pivot_rotation
	set_particle_intensity(wind_strength)
	wind = wind_strength * wind_direction

func set_particle_intensity(wind_strength: float) -> void:
	if wind_strength < 1:
		%RainParticles.intensity_off()
		%SwirlingLeafParticles.intensity_off()
		storm_strength.emit(0)
	elif wind_strength >= 1 && wind_strength < 2:
		%RainParticles.intensity_off()
		%SwirlingLeafParticles.intensity_low()
		storm_strength.emit(1)
	elif wind_strength >= 2 && wind_strength < 3:
		%RainParticles.intensity_low()
		%SwirlingLeafParticles.intensity_low()
		storm_strength.emit(2)
	elif wind_strength >= 3 && wind_strength < 4:
		%RainParticles.intensity_low()
		%SwirlingLeafParticles.intensity_mid()
		storm_strength.emit(3)
	elif wind_strength >= 4 && wind_strength < 5:
		%RainParticles.intensity_mid()
		%SwirlingLeafParticles.intensity_mid()
		storm_strength.emit(4)
	elif wind_strength >= 5 && wind_strength < 6:
		%RainParticles.intensity_mid()
		%SwirlingLeafParticles.intensity_high()
		storm_strength.emit(5)
	elif wind_strength >= 6 && wind_strength < 7:
		%RainParticles.intensity_high()
		%SwirlingLeafParticles.intensity_high()
		storm_strength.emit(6)
	elif wind_strength >= 7 && wind_strength < 8:
		%RainParticles.intensity_high()
		%SwirlingLeafParticles.intensity_super()
		storm_strength.emit(7)
	elif wind_strength >= 8 && wind_strength < 9:
		%RainParticles.intensity_super()
		%SwirlingLeafParticles.intensity_super()
		storm_strength.emit(8)
	else:
		%RainParticles.intensity_typhoon()
		%SwirlingLeafParticles.intensity_typhoon()
		storm_strength.emit(9)
