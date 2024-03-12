extends CharacterBody2D

@export var MAX_SPEED: float = 300.0
@export var ACCELERATION: float = 40.0
@export var ROTATION_SPEED: float = 3.5

var blend_position = 0
var return_speed = 2

var current_speed = 0.0

func get_input(delta):
	var rotation_direction = Input.get_axis("left", "right")
	var move_direction = Input.get_axis("up", "down")

	rotation += rotation_direction * ROTATION_SPEED * delta
	
	if rotation_direction != 0:
		blend_position = lerp(float(blend_position), float(rotation_direction), return_speed * delta)
	else:
		if blend_position != 0:
			blend_position = lerp(float(blend_position), 0.0, return_speed * delta)

	$AnimationTree.set("parameters/blend_position", blend_position)
	
	# Get vector of current speed addition and add it to the current velocity
	if move_direction == -1:
		var velocity_increment = Vector2(cos(rotation), sin(rotation)) * move_direction * ACCELERATION * delta
		velocity = velocity + velocity_increment
	elif move_direction == 1:
		# if back is hit, slow the character using "inertial brakes" and lerp
		if velocity.length() != 0:
			if velocity.length() < 1:
				velocity = Vector2.ZERO
			else:
				velocity = velocity.lerp(Vector2.ZERO, 0.01)

		#velocity.x = lerp(velocity.x, 0, 0.1)
		#velocity.y = lerp(velocity.y, 0, 0.1)
	
	
	

	#var forward = Vector2(cos(rotation), sin(rotation))
#
	#if move_direction != 0:
		#current_speed += ACCELERATION * move_direction * delta
		#current_speed = clamp(current_speed, -MAX_SPEED, MAX_SPEED)
	#else:
		#current_speed = lerp(current_speed, 0.0, 0.5 * delta)
#
	#velocity = velocity + forward * current_speed

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
