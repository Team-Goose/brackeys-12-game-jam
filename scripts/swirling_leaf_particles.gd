extends Node2D

func intensity_off() -> void:
	$SwirlingLeafGPUParticles.emitting = false

func intensity_calm() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 10

func intensity_woosh() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 25
func intensity_turbulent() -> void:
	$SwirlingLeafGPUParticles.emitting = true
	$SwirlingLeafGPUParticles.amount = 50
