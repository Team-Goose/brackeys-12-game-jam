extends Node2D

signal storm_strength_changed(val: int)
signal game_over

@onready var forg := $Forg
@onready var lhand := $LHand
@onready var rhand := $RHand
@onready var lhand_line := $LHandLine
@onready var rhand_line := $RHandLine
@onready var camera := $Forg/Camera2D
@onready var grab_sound := $GrabSoundEffect
@onready var timer := $Timer
@onready var sweat := $Forg/Sweat
@onready var stamina_bar_l := $Forg/Control/StaminaL
@onready var stamina_bar_r := $Forg/Control/StaminaR

var active_hand_left := true
var storm_strength := 0
var stamina := 0.0
var player_alive := true
var go_direction := Vector2((randf()-0.5) * 500.0, -500)
var last_pos := Vector2(0.0, 0.0)

func _ready() -> void:
	sweat.play()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"):
		# Params to collide with Area2Ds on canvas 0
		var params := PhysicsPointQueryParameters2D.new()
		params.position = lhand.global_position if active_hand_left else rhand.global_position
		params.collide_with_areas = true
		
		var result := get_world_2d().direct_space_state.intersect_point(params, 1)
		if result.size() == 1:
			var tree_cell: TreeCell = result.front().collider.get_parent()
			stamina = (float(tree_cell.hold_strength) / float(storm_strength)) * (stamina if stamina > 0.0 else 1.0)
			timer.start(stamina)
			if active_hand_left:
				lhand.global_position = tree_cell.global_position
			else:
				rhand.global_position = tree_cell.global_position
			active_hand_left = !active_hand_left
			grab_sound.pitch_scale = (randf() / 2.0) + 0.75
			grab_sound.play()

func _process(delta: float) -> void:
	if player_alive:
		move_hand(active_hand_left)
		move_forg()
		rotate_hand()
		sweat.visible = timer.time_left < 0.8 && !timer.is_stopped()
		var size = timer.time_left * 10.0 if timer.time_left * 10.0 < 20.0 else 20.0
		stamina_bar_l.size.x = size
		stamina_bar_r.size.x = size
		$Forg/Control/Label.text = str(timer.time_left).pad_decimals(3)
		last_pos = camera.global_position
	else:
		camera.global_position = last_pos
		forg.global_position += go_direction * delta
		go_direction.y += 980 *delta

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


func _on_timer_timeout() -> void:
	player_alive = false
	timer.start(5.0)
	#game_over.emit()
	#print("game over!")
