class_name RainParticles extends Node2D

func intensity_off() -> void:
	$RainCPUParticle.emitting = false

func intensity_drizzle() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 50

func intensity_rain() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 300

func intensity_downpour() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 1000
