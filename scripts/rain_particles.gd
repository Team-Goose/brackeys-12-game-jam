class_name RainParticles extends Node2D

func intensity_off() -> void:
	$RainCPUParticle.emitting = false

func intensity_low() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 50

func intensity_mid() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 300

func intensity_high() -> void:
	$RainCPUParticle.emitting = true
	$RainCPUParticle.amount = 1000
