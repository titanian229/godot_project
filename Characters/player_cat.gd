extends CharacterBody2D

@export var MAX_SPEED: float = 300.0
@export var ACCELERATION: float = 20.0
@export var ROTATION_SPEED: float = 3.5

var current_speed = 0.0

func get_input(delta):
	var rotation_direction = Input.get_axis("left", "right")
	var move_direction = Input.get_axis("up", "down")


	rotation += rotation_direction * ROTATION_SPEED * delta

	var forward = Vector2(cos(rotation), sin(rotation))

	if move_direction != 0:
		current_speed += ACCELERATION * move_direction * delta
		current_speed = clamp(current_speed, -MAX_SPEED, MAX_SPEED)
	else:
		current_speed = lerp(current_speed, 0.0, 0.5 * delta)

	velocity = forward * current_speed

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
