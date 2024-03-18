extends CharacterBody2D

@export var MAX_SPEED: float = 3000.0
#@export var ACCELERATION: float = 40.0
@export var ACCELERATION: float = 80.0
@export var ROTATION_SPEED: float = 3.5
@onready var camera_2d = $Camera2D

#@onready var blackhole = $"../black_hole/black_hole_sprite"
@onready var animation_tree = $AnimationTree
@onready var space_scene = $".."
@onready var world = $"../.."

var blend_position = 0
var return_speed = 2

var current_speed = 0.0

var mass_player = 1
var true_mass = 1
# TODO: Move this to exports from each and generalize, player should loop through all bodies in array in global

var max_gravity_distance = 10000

var debounce_jump_period: float = 1.5
var debounce_jump_timer: Timer

var jumping_period: float = 0.4
var jump_timer: Timer

var jump_ratio: float = 2000.0

var prejump_velocity: Vector2 = Vector2.ZERO

var debounce_warpto_time: float = 2.0
var debounce_warpto_timer: Timer

var debounce_warptotargetacquire_time: float = 0.5
var debounce_warptotargetacquire_timer: Timer

func _ready():
	debounce_jump_timer = Timer.new()
	debounce_jump_timer.wait_time = debounce_jump_period
	debounce_jump_timer.one_shot = true
	add_child(debounce_jump_timer)
	debounce_jump_timer.connect("timeout", self._on_jump_timer_timeout)
	
	jump_timer = Timer.new()
	jump_timer.wait_time = jumping_period
	jump_timer.one_shot = true
	add_child(jump_timer)
	jump_timer.connect("timeout", self._on_jump_complete_timer_timeout)
	
	debounce_warpto_timer = Timer.new()
	debounce_warpto_timer.wait_time = debounce_warpto_time
	debounce_warpto_timer.one_shot = true
	add_child(debounce_warpto_timer)
	debounce_warpto_timer.connect("timeout", self._on_warpto)
	
	debounce_warptotargetacquire_timer = Timer.new()
	debounce_warptotargetacquire_timer.wait_time = debounce_warptotargetacquire_time
	debounce_warptotargetacquire_timer.one_shot = true
	add_child(debounce_warptotargetacquire_timer)
	debounce_warptotargetacquire_timer.connect("timeout", self.start_onwarpto)


func _on_jump_timer_timeout():
	print("JUMP")
	jump_timer.start()
	var jump_vector = Vector2(cos(rotation), sin(rotation)).rotated(PI).normalized() # * 10
	print("Jump_Vector: ", jump_vector)
	velocity += jump_vector * jump_ratio


func _on_jump_complete_timer_timeout():
	print("JUMP_DONE")
	#velocity -= velocity.normalized() * jump_ratio
	
	velocity = velocity.lerp(Vector2.ZERO, 0.95)
	
var warp_target = null

func start_onwarpto():
	if (debounce_warpto_timer.time_left > 0):
		return
		
	var player_direction = Vector2(cos(rotation), sin(rotation)).rotated(PI)
	
	var smallest_angle = null
	var smallest_angle_body
	
	for body in space_scene.bodies_in_space:
		var direction_to_object = (body.global_position - global_position).normalized()
		var angle_to_object = player_direction.angle_to(direction_to_object)
		if (abs(angle_to_object) < 2.3):
			if (smallest_angle == null):
				smallest_angle = angle_to_object
				smallest_angle_body = body
			else:
				if (abs(angle_to_object) < abs(smallest_angle)):
					smallest_angle = angle_to_object
					smallest_angle_body = body
					
	warp_target = smallest_angle_body
	#debounce_warpto_timer.stop()
	#debounce_warpto_timer.start()
	

func _on_warpto():
	# Iterate objects, find closest to what I'm pointed at
	if (warp_target != null):
		print(warp_target.name)
			
		# Set player to position of body + 100
		position = warp_target.position + Vector2(200,0)
		#velocity = warp_target.velocity
		
		# calculate orbital speed around body
		
		var orbital_velocity = sqrt((space_scene.G * warp_target.true_mass) / 200)
		var vector_to_body = warp_target.global_position - global_position
		var orbital_direction = (vector_to_body.rotated(PI / 2)).normalized()
		
		velocity = orbital_velocity * orbital_direction + warp_target.velocity
		
		warp_target = null
		

	

func get_input(delta):
	if (Input.is_action_pressed("Ship_Jump")): # and not debounce_jump_timer.is_stopped()):
		debounce_jump_timer.stop()
		debounce_jump_timer.start()
	if (Input.is_action_pressed("WarpTo")): # and not debounce_jump_timer.is_stopped()):
		debounce_warpto_timer.stop()
		debounce_warpto_timer.start()
	if (Input.is_action_pressed("WarpToTargetAcquire")):
		debounce_warptotargetacquire_timer.stop()
		debounce_warptotargetacquire_timer.start()
		
		
	var rotation_direction = Input.get_axis("left", "right")
	var move_direction = Input.get_axis("up", "down")

	rotation += rotation_direction * ROTATION_SPEED * delta
	
	if rotation_direction != 0:
		blend_position = lerp(float(blend_position), float(rotation_direction), return_speed * delta)
	else:
		if blend_position != 0:
			blend_position = lerp(float(blend_position), 0.0, return_speed * delta)
	animation_tree.set("parameters/blend_position", blend_position)
	
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
				velocity = velocity.lerp(Vector2.ZERO, 0.05)
	
	#var blackhole = get_node("/root/black_hole/black_hole_sprite")


func calculate_gravity(delta):
	if space_scene:
		var gravity_velocity_influence = Vector2.ZERO
		for body in space_scene.bodies_in_space:
			var distance_to_body = global_position.distance_to(body.global_position)
			if (distance_to_body < max_gravity_distance):
				var vector_to_target = body.global_position - global_position
				var a_g = ((space_scene.G * body.true_mass)/(distance_to_body**2)) * vector_to_target.normalized()
				gravity_velocity_influence += a_g * delta
				
		get_node("GravityEffect").process_material.gravity = Vector3(gravity_velocity_influence.x, gravity_velocity_influence.y, 1) * 1000
		
func _physics_process(delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.get_collider().name)
		warp_target = space_scene.bodies_in_space[len(space_scene.bodies_in_space) - 1]
		_on_warpto()
		
	get_input(delta)
	calculate_gravity(delta)
	move_and_slide()
	#
	#var collision = move_and_collide(velocity * delta)
	#if collision:
		#print("Collision", collision.get_collider().name)
		#velocity = velocity.slide(collision.get_normal())
