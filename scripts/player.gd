extends Node2D

@onready var forg = $Forg
@onready var lhand = $LHand
@onready var rhand = $RHand
@onready var camera = $Forg/Camera2D

var active_hand_left := true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"):
		# Params to collide with Area2Ds on canvas 0
		var params := PhysicsPointQueryParameters2D.new()
		params.position = lhand.global_position if active_hand_left else rhand.global_position
		params.collide_with_areas = true
		
		var result = get_world_2d().direct_space_state.intersect_point(params, 1)
		if result.size() == 1:
			if active_hand_left:
				lhand.global_position = result.front().collider.global_position
			else:
				rhand.global_position = result.front().collider.global_position
			active_hand_left = !active_hand_left

func _process(delta: float) -> void:
	move_hand(active_hand_left)
	pass

func move_hand(hand: bool):
	if hand:
		lhand.global_position = calc_hand_pos(rhand.global_position)
	else:
		rhand.global_position = calc_hand_pos(lhand.global_position)
	forg.global_position = lhand.global_position/2 + rhand.global_position/2

func calc_hand_pos(inactive_hand_pos: Vector2):
	var mouse_pos = get_global_mouse_position()
	var difference = get_global_mouse_position()-inactive_hand_pos
	var max = inactive_hand_pos + (difference.normalized()*256)
	
	return mouse_pos if inactive_hand_pos.distance_to(max) > inactive_hand_pos.distance_to(mouse_pos) else max
