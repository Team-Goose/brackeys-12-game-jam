extends Node2D

var intensity := 0

func intensity_off() -> void:
	if intensity != 0:
		for i in 25:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 1))
			n.emitting = false
		#$SwirlingLeafGPUParticles.amount = 0
		intensity = 0

func intensity_low() -> void:
	if intensity != 1:
		$SwirlingLeafGPUParticles1.emitting = true
		for i in 24:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 2))
			n.emitting = false
		#$SwirlingLeafGPUParticles.amount = 10
		intensity = 1

func intensity_mid() -> void:
	if intensity != 2:
		for i in 3:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 1))
			n.emitting = true
		for i in 22:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 4))
			n.emitting = false
		#$SwirlingLeafGPUParticles.amount = 30
		intensity = 2

func intensity_high() -> void:
	if intensity != 3:
		for i in 5:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 1))
			n.emitting = true
		for i in 20:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 6))
			n.emitting = false
		#$SwirlingLeafGPUParticles.amount = 50
		intensity = 3

func intensity_super() -> void:
	if intensity != 4:
		for i in 10:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 1))
			n.emitting = true
		for i in 15:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 11))
			n.emitting = false
		#$SwirlingLeafGPUParticles.amount = 100
		intensity = 4

func intensity_typhoon() -> void:
	if intensity != 5:
		for i in 25:
			var n: GPUParticles2D = get_node("SwirlingLeafGPUParticles" + str(i + 1))
			n.emitting = true
		#$SwirlingLeafGPUParticles.amount = 250
		intensity = 5
