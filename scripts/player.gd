extends Node2D

@onready var lhand = $LHand
@onready var rhand = $RHand

var active_hand_left := true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"):
		# Params to collide with Area2Ds on canvas 0
		var params = PhysicsPointQueryParameters2D.new()
		params.position = get_global_mouse_position()
		params.collide_with_areas = true
		
		var result = get_world_2d().direct_space_state.intersect_point(params, 1)
		if result.size() == 1:
			move_hand(active_hand_left, result.front().collider.global_position)
		
		active_hand_left = !active_hand_left
		
		global_position.y -= 50

func _process(delta: float) -> void:
	move_hand(active_hand_left, get_global_mouse_position())
	pass

func move_hand(hand: bool, pos: Vector2):
	if hand:
		lhand.global_position = pos
	else:
		rhand.global_position = pos
