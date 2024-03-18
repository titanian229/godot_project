extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var space_scene = get_node("/root/World/SpaceScene")
@export var mass = float(1)
@export var mass_scale = float(1)
@onready var true_mass = mass * (10**mass_scale)
#var true_mass = 10
@export var initial_velocity = Vector2.ZERO
@export var type = "FIXED"

func get_stable_orbital_velocity_direction():
	var gravity_velocity_influence = Vector2.ZERO
	for body in space_scene.bodies_in_space:
		var distance_to_body = global_position.distance_to(body.global_position)
		if (body != self && distance_to_body > 1):
			var vector_to_target = body.global_position - global_position
			var force_magnitude = space_scene.G * (true_mass * body.true_mass) / distance_to_body**2
			var gravitational_force = vector_to_target.normalized() * force_magnitude
			#print("gf ", gravitational_force * delta)
			gravity_velocity_influence += gravitational_force
	# Rotate the grav force by pi/2 and normalize
	var normal = (gravity_velocity_influence.rotated(PI / 2)).normalized()
	return normal
	#based on gravitational force and distance, 
	
func get_center_of_mass_and_total_mass(include_self = false):
	#print("Running script for : ", self.name)
	var total_mass = 0
	var center_of_mass = Vector2.ZERO
	for body in space_scene.bodies_in_space:
		#print(body.name)
		var distance_to_body = global_position.distance_to(body.global_position)
		#print(distance_to_body)
		if (body != self && self.name != body.name && distance_to_body > 1):
			total_mass += body.true_mass
			center_of_mass += body.global_position * body.true_mass
			#print("Body name: %s, Mass: %s, Total mass: %s, Position: %s" % [body.name, str(body.true_mass), str(total_mass), str(body.global_position)])

	if total_mass != 0:
		center_of_mass /= total_mass
	#print("CM: ", center_of_mass)
	return {"center_of_mass": center_of_mass, "total_mass": total_mass}

func get_stable_orbital_velocity():
	var mass_data = get_center_of_mass_and_total_mass()
	var center_of_mass = mass_data["center_of_mass"]
	var total_mass = mass_data["total_mass"]
	var distance_to_com = global_position.distance_to(center_of_mass)

	# Avoid division by zero
	if distance_to_com == 0 or total_mass == 0:
		return 0

	var orbital_velocity = sqrt((space_scene.G * total_mass) / distance_to_com)
	return orbital_velocity

func get_stable_orbital_velocity_single_body(body):
	var distance_to_mass = global_position.distance_to(body.global_position)

	# Avoid division by zero
	if distance_to_mass == 0:
		return 0

	var orbital_velocity = sqrt((space_scene.G * body.true_mass) / distance_to_mass)
	return orbital_velocity
	
func get_stable_orbital_velocity_vector_single_body(body):
	var vector_to_target = body.global_position - global_position
	# Rotate the grav force by pi/2 and normalize
	var normal = (vector_to_target.rotated(PI / 2)).normalized()
	return normal

func orthogonal_vel_approach():
	
	var gravity_velocity_influence = Vector2.ZERO
	for body in space_scene.bodies_in_space:
			
		var distance_to_body = global_position.distance_to(body.global_position)
		if (body != self && distance_to_body > 1):
			var vector_to_target = body.global_position - global_position
			#print("vec: ", vector_to_target)
			
			var force_magnitude = space_scene.G * (true_mass * body.true_mass) / distance_to_body**2
			var gravitational_force = vector_to_target.normalized() * force_magnitude
			#print("gf ", gravitational_force * delta)
			gravity_velocity_influence += gravitational_force
			
	# Rotate the velocity 


# Called when the node enters the scene tree for the first time.
func _ready():
	#true_mass = mass * 10**mass_scale
	if (type == "FIXED"):
		return
		
	space_scene.bodies_in_space.append(self)
	#velocity = initial_velocity
	#var orbital_velocity = get_stable_orbital_velocity()
	#var orbital_direction = get_stable_orbital_velocity_direction()
	##print(orbital_direction)
	#velocity += orbital_velocity * orbital_direction
	
	#var gravity_velocity_influence = Vector2.ZERO
	#for body in space_scene.bodies_in_space:
			#
		#var distance_to_body = global_position.distance_to(body.global_position)
		#if (body != self && distance_to_body > 1):
			#var vector_to_target = body.global_position - global_position
			#var a_g = ((space_scene.G * body.true_mass)/(distance_to_body**2)) * vector_to_target.normalized()
			#gravity_velocity_influence += a_g
	#velocity = gravity_velocity_influence.rotated(PI/2)
	
	#move_and_slide()

#var has_readied = false
var initial_frames_wait = 30
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	return
	if (type == "FIXED"):
		return
	
	if (initial_frames_wait > 0):
		initial_frames_wait -= 1
		return
	elif (initial_frames_wait == 0):
		initial_frames_wait -= 1
		var orbital_velocity = get_stable_orbital_velocity()
		var orbital_direction = get_stable_orbital_velocity_direction()
		#print(orbital_direction)
		velocity = orbital_velocity * orbital_direction
		move_and_slide()
		return
	
	
	
		
	move_and_slide()
	
	#var cm_data = get_center_of_mass_and_total_mass()
	#var center_of_mass = cm_data["center_of_mass"]
	#var total_mass = cm_data["total_mass"]
	#var distance_to_com = global_position.distance_to(center_of_mass)
	#var vector_to_cm = center_of_mass - global_position
	#
	#var force_magnitude = space_scene.G * (mass * total_mass) / distance_to_com**2
	#var gravitational_force = vector_to_cm.normalized() * force_magnitude
	#var gravity_velocity_influence = gravitational_force * delta
	#
	
	var gravity_velocity_influence = Vector2.ZERO
	for body in space_scene.bodies_in_space:
			
		var distance_to_body = global_position.distance_to(body.global_position)
		if (body != self && distance_to_body > 1):
			var vector_to_target = body.global_position - global_position
			#print("vec: ", vector_to_target)
			
			#var force_magnitude = space_scene.G * (true_mass * body.true_mass) / distance_to_body**2
			var a_g = ((space_scene.G * body.true_mass)/(distance_to_body**2)) * vector_to_target.normalized()
			#var gravitational_force = vector_to_target.normalized() * force_magnitude
			#print("gf ", gravitational_force * delta)
			gravity_velocity_influence += a_g * delta
			#print("g: ", gravity_velocity_influence)
	##print(velocity)

	velocity += gravity_velocity_influence
	#move_and_slide()
