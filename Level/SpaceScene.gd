extends Node2D

var bodies_in_space = []
@export var G = 6.67430e4 # 4
@onready var player = $PlayerCat
@onready var world = $".."

var progress_nograv = 100
@export var isolated_range = 500

func get_stable_orbital_velocity_direction(target):
	var gravity_velocity_influence = Vector2.ZERO
	for body in bodies_in_space:
		var distance_to_body = target.global_position.distance_to(body.global_position)
		if (body != target && distance_to_body > 1):
			var vector_to_target = body.global_position - target.global_position
			var force_magnitude = G * (target.true_mass * body.true_mass) / distance_to_body**2
			var gravitational_force = vector_to_target.normalized() * force_magnitude
			#print("gf ", gravitational_force * delta)
			gravity_velocity_influence += gravitational_force
	# Rotate the grav force by pi/2 and normalize
	var normal = (gravity_velocity_influence.rotated(PI / 2)).normalized()
	return normal
	#based on gravitational force and distance, 
	
func get_center_of_mass_and_total_mass(target):
	var total_mass = 0
	var center_of_mass = Vector2.ZERO
	for body in bodies_in_space:
		var distance_to_body = target.global_position.distance_to(body.global_position)
		if (body != target && target.name != body.name && distance_to_body > 1):
			total_mass += body.true_mass
			center_of_mass += body.global_position * body.true_mass
			#print("Body name: %s, Mass: %s, Total mass: %s, Position: %s" % [body.name, str(body.true_mass), str(total_mass), str(body.global_position)])

	if total_mass != 0:
		center_of_mass /= total_mass
	#print("CM: ", center_of_mass)
	return {"center_of_mass": center_of_mass, "total_mass": total_mass}

func get_stable_orbital_velocity(target):
	var mass_data = get_center_of_mass_and_total_mass(target)
	var center_of_mass = mass_data["center_of_mass"]
	var total_mass = mass_data["total_mass"]
	var distance_to_com = target.global_position.distance_to(center_of_mass)

	# Avoid division by zero
	if distance_to_com == 0 or total_mass == 0:
		return 0

	var orbital_velocity = sqrt((G * total_mass) / distance_to_com)
	return orbital_velocity



func get_frame_acceleration(target, delta, is_player = false):
	var gravity_velocity_influence = Vector2.ZERO
	for body in bodies_in_space:
		var distance_to_body = target.global_position.distance_to(body.global_position)
		if (body != target && distance_to_body > 1):
				
			var vector_to_target = body.global_position - target.global_position
			var a_g = ((G * body.true_mass)/(distance_to_body**2)) * vector_to_target.normalized()
			#if (is_player):
				#print(body.name, " : ", distance_to_body)
			#if (is_player && distance_to_body < isolated_range):
				#print("Solo impact ", body.name)
				## if the player is inside the close range of a body, remove impact of other bodies
				#gravity_velocity_influence = a_g * delta
				#break
				
			gravity_velocity_influence += a_g * delta
	return gravity_velocity_influence


# Called when the node enters the scene tree for the first time.
func _ready():
	for body in bodies_in_space:
		var orbital_velocity = get_stable_orbital_velocity(body)
		var orbital_direction = get_stable_orbital_velocity_direction(body)
		body.velocity = orbital_velocity * orbital_direction
	
	var orbital_velocity = get_stable_orbital_velocity(player)
	var orbital_direction = get_stable_orbital_velocity_direction(player)
	player.velocity = orbital_velocity * orbital_direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Iterate all children and update their velocity
	for body in bodies_in_space:
		body.velocity += get_frame_acceleration(body, delta)
		

	#elif (map_lock == true):
		#map_lock = false
	
	# gravitational influence on player
	if (!world.no_gravity && !world.map_lock):
		# Check if player is VERY close to something and make that the only item impacting it
		
		player.velocity += get_frame_acceleration(player, delta, true)
