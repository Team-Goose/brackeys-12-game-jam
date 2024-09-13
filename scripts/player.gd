extends Node2D

signal storm_strength_changed(val: int)

@onready var forg := $Forg
@onready var lhand := $LHand
@onready var rhand := $RHand
@onready var lhand_line := $LHandLine
@onready var rhand_line := $RHandLine
@onready var camera := $Forg/Camera2D

var active_hand_left := true
var storm_strength := 0

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
			$GrabSoundEffect.pitch_scale = (randf() / 2.0) + 0.75
			$GrabSoundEffect.play()

func _process(delta: float) -> void:
	move_hand(active_hand_left)
	move_forg()
	rotate_hand()
	pass

func move_forg():
	# active and incative hand positions
	var apos = lhand.global_position if active_hand_left else rhand.global_position
	var ipos = rhand.global_position if active_hand_left else lhand.global_position
	
	forg.global_position = Vector2(apos.x*.3 + ipos.x*.7, apos.y*.1 + ipos.y*.9)

func move_hand(hand: bool):
	if hand:
		lhand.global_position = calc_hand_pos(rhand.global_position)
	else:
		rhand.global_position = calc_hand_pos(lhand.global_position)
	lhand_line.points = [lhand.position, forg.position]
	rhand_line.points = [rhand.position, forg.position]

func calc_hand_pos(inactive_hand_pos: Vector2):
	var mouse_pos = get_global_mouse_position()
	var difference = get_global_mouse_position()-inactive_hand_pos
	var max = inactive_hand_pos + (difference.normalized()*180)
	
	return mouse_pos if inactive_hand_pos.distance_to(max) > inactive_hand_pos.distance_to(mouse_pos) else max

func rotate_hand():
	lhand.rotation = forg.global_position.angle_to_point(lhand.global_position) + deg_to_rad(90)
	rhand.rotation = forg.global_position.angle_to_point(rhand.global_position) + deg_to_rad(90)


func _on_storm_strength_change(val: int) -> void:
	if storm_strength != val:
		storm_strength = val
		storm_strength_changed.emit(val)
