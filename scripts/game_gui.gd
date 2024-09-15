class_name GameGUI extends Control

const DAY_START_COLOR := Color('6e6a000c')
const DAY_END_COLOR := Color('06275054')

var start_time := Time.get_ticks_msec()
var current_time := Time.get_ticks_msec()

func _process(_delta: float) -> void:
	current_time = Time.get_ticks_msec()
	var seconds_left: int = 120 - ((current_time - start_time) / 1000)
	if seconds_left >= 0:
		%TimeLabel.text = str(seconds_left) + ' seconds left today!'
	%TyphoonWarningLabel.modulate.a = (sin(current_time / 1000.0 * 2) + 1.0) / 2.0

func show_warning() -> void:
	%TyphoonWarningLabel.visible = true

func hide_warning() -> void:
	%TyphoonWarningLabel.visible = false

func set_score(score: int = 0) -> void:
	%ScoreLabel.text = 'Score: ' + str(score)

func set_color(proportion_time_passed: float) -> void:
	%TimeFilter.color = DAY_START_COLOR.lerp(DAY_END_COLOR, proportion_time_passed)

func set_day(day: int) -> void:
	%DayLabel.text = 'Day ' + str(day)
