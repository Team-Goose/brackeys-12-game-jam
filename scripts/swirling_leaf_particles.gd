extends Node2D

func intensity_off() -> void:
	$SwirlingLeafGPUParticles.emitting = false

func intensity_low() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 10

func intensity_mid() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 25

func intensity_high() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 50
