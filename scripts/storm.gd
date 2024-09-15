class_name Storm extends Node2D

signal storm_strength(val: int)

var time_start := 0
var wind := Vector2.ZERO
var day := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = Time.get_ticks_msec() / 1000.0
	%RainParticles.intensity_off()
	%SwirlingLeafParticles.intensity_off()

func set_day(new_day: int) -> void:
	day = new_day

func _physics_process(delta: float) -> void:
	var time_now = Time.get_ticks_msec() / 1000.0
	var time_elapsed = time_now - time_start
	var wind_strength = get_wind_strength(time_elapsed)
	var wind_direction = Vector2.RIGHT
	var particle_pivot_rotation = 90 * sin(time_elapsed / 10.0) # range from -90 to 90 on a sine curve
	%ParticlePivot.global_rotation_degrees = particle_pivot_rotation
	set_particle_intensity(wind_strength)
	wind = wind_strength * wind_direction

func get_wind_strength(sec_elapsed) -> float:
	match day:
		1:
			return 3.2 - pow(10, 0.5 - (sec_elapsed / 40.0))
		2:
			return 5.2 - pow(12, 0.5 - (sec_elapsed / 15.0))
		3:
			return 7.2 - pow(15, 0.5 - (sec_elapsed / 20.0))
		4:
			return 9.2 - pow(80, 0.5 - (sec_elapsed / 50.0))
		_:
			var divisor: float = max(60.0 - day, 0.5)
			return (5 * sin(sec_elapsed / divisor)) + 5 # range from 0 to 10 on a sine curve with frequency determined by day

func set_particle_intensity(wind_strength: float) -> void:
	if wind_strength < 1:
		%RainParticles.intensity_off()
		%SwirlingLeafParticles.intensity_off()
		%WindParticles.intensity_off()
		storm_strength.emit(0)
	elif wind_strength >= 1 && wind_strength < 2:
		%RainParticles.intensity_off()
		%SwirlingLeafParticles.intensity_low()
		%WindParticles.intensity_low()
		storm_strength.emit(1)
	elif wind_strength >= 2 && wind_strength < 3:
		%RainParticles.intensity_low()
		%SwirlingLeafParticles.intensity_low()
		%WindParticles.intensity_low()
		storm_strength.emit(2)
	elif wind_strength >= 3 && wind_strength < 4:
		%RainParticles.intensity_low()
		%SwirlingLeafParticles.intensity_mid()
		%WindParticles.intensity_mid()
		storm_strength.emit(3)
	elif wind_strength >= 4 && wind_strength < 5:
		%RainParticles.intensity_mid()
		%SwirlingLeafParticles.intensity_mid()
		%WindParticles.intensity_mid()
		storm_strength.emit(4)
	elif wind_strength >= 5 && wind_strength < 6:
		%RainParticles.intensity_mid()
		%SwirlingLeafParticles.intensity_high()
		%WindParticles.intensity_high()
		storm_strength.emit(5)
	elif wind_strength >= 6 && wind_strength < 7:
		%RainParticles.intensity_high()
		%SwirlingLeafParticles.intensity_high()
		%WindParticles.intensity_high()
		storm_strength.emit(6)
	elif wind_strength >= 7 && wind_strength < 8:
		%RainParticles.intensity_high()
		%SwirlingLeafParticles.intensity_super()
		%WindParticles.intensity_super()
		storm_strength.emit(7)
	elif wind_strength >= 8 && wind_strength < 9:
		%RainParticles.intensity_super()
		%SwirlingLeafParticles.intensity_super()
		%WindParticles.intensity_super()
		storm_strength.emit(8)
	else:
		%RainParticles.intensity_typhoon()
		%SwirlingLeafParticles.intensity_typhoon()
		%WindParticles.intensity_typhoon()
		storm_strength.emit(9)
