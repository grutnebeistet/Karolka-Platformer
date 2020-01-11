extends Actor

# extends Actor, therefore will run super's _physics_process
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("move_jump") and _velocity.y < 0.0
#	 y direction should be 1 (falling) by default, except when jumping -1
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2: 
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
				-1.0 if Input.is_action_just_pressed("move_jump") and is_on_floor() else 1.0
#				Input.get_action_strength("move_jump") 
	)
	
func calculate_move_velocity(
		linear_velocity: Vector2, 
		direction: Vector2,
		speed: Vector2, 
		jump_interrupted: bool
	) -> Vector2:
	var new_velocity: = linear_velocity 
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if jump_interrupted: 
		new_velocity.y = 0.0
	return new_velocity