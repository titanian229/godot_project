extends CharacterBody2D

@onready var space_scene = get_node("/root/World/SpaceScene")
@export var mass = float(100)
@export var mass_scale = float(1)
@export var type = "BLACKHOLE"
var true_mass = mass * (10**mass_scale)

func _ready():
	space_scene.bodies_in_space.append(self)


var initial_frames_wait = 30
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	#return
	#move_and_slide()
	#return
	#if (type == "FIXED"):
		#return
	#
	#if (initial_frames_wait > 0):
		#initial_frames_wait -= 1
		#return
	#elif (initial_frames_wait == 0):
		#initial_frames_wait -= 1
		#var orbital_velocity = space_scene.get_stable_orbital_velocity(self)
		#var orbital_direction = space_scene.get_stable_orbital_velocity_direction(self)
		##print(orbital_direction)
		#velocity = orbital_velocity * orbital_direction
		#move_and_slide()
		#return
		#
	#move_and_slide()
	#
	#velocity += space_scene.get_frame_acceleration(self, delta)
