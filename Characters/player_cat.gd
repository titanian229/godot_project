extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -400.0
@export var rotation_speed = 3.5
const ACCELERATION = 150
const STOP_SPEED = .1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rotation_direction = 0

func slow_and_stop():
	velocity.x += (-velocity.x * STOP_SPEED)
	if velocity.x > 0 and velocity.x < 100:
		velocity.x = 0
	elif velocity.x < 0 and velocity.x > -100:
		velocity.x = 0

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	#velocity = transform.x * Input.get_axis("down", "up") * SPEED
	if Input.is_action_pressed("up") and Input.is_action_pressed("down"):
		slow_and_stop()
	elif Input.is_action_pressed("up"):
		velocity = transform.x * Input.get_axis("down", "up") * SPEED
		#velocity.x += ACCELERATION
	elif Input.is_action_pressed("down"):
		velocity = transform.x * Input.get_axis("down", "up") * -SPEED
		#velocity.x -= ACCELERATION
	else:
		slow_and_stop()
#	Clamp movement to speed
	velocity.x = clamp(velocity.x, -SPEED, SPEED)
	velocity.y = clamp(velocity.y, -SPEED, SPEED)


func _physics_process(delta):
	
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_direction = Vector2(
		#Input.get_action_strength("right") - Input.get_action_strength("left"),
		#Input.get_action_strength("down") - Input.get_action_strength("up")
	#)
	
	#velocity = input_direction * SPEED
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

