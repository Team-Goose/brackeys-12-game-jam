class_name RainParticles extends Node2D

var intensity := 0

func intensity_off() -> void:
	if intensity != 0:
		for i in 60:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 1))
			n.emitting = false
		#$RainCPUParticle.amount = 0
		intensity = 0

func intensity_low() -> void:
	if intensity != 1:
		$RainCPUParticle1.emitting = true
		for i in 59:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 2))
			n.emitting = false
		#$RainCPUParticle.amount = 50
		intensity = 1

func intensity_mid() -> void:
	if intensity != 2:
		for i in 6:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 1))
			n.emitting = true
		for i in 54:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 7))
			n.emitting = false
		#$RainCPUParticle.amount = 300
		intensity = 2

func intensity_high() -> void:
	if intensity != 3:
		for i in 20:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 1))
			n.emitting = true
		for i in 40:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 21))
			n.emitting = false
		#$RainCPUParticle.amount = 1000
		intensity = 3

func intensity_super() -> void:
	if intensity != 4:
		for i in 40:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 1))
			n.emitting = true
		for i in 20:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 41))
			n.emitting = false
		#$RainCPUParticle.amount = 2000
		intensity = 4

func intensity_typhoon() -> void:
	if intensity != 5:
		for i in 60:
			var n: CPUParticles2D = get_node("RainCPUParticle" + str(i + 1))
			n.emitting = true
		#$RainCPUParticle.amount = 3000
		intensity = 5
