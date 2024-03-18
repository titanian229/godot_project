extends Node2D

@export var toggle_window = 10

var no_gravity = false
var zoom_out = false

const DECREMENT_SPEED = 1
const INCREMENT_SPEED = 0.05

var no_gravity_counter = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var map_lock = false
# When the input key is detected, toggle the state and reset a counter
# ever frame decrement the counter
var toggle_window_map_lock = 0

func _process(delta):
	if (toggle_window_map_lock > 0):
		toggle_window_map_lock -= 1
		
	if (Input.is_action_pressed("Map_Lock") && toggle_window_map_lock == 0):
		toggle_window_map_lock = toggle_window
		map_lock = !map_lock
		#no_gravity = true
		#zoom_out = true
	
	#if (!map_lock && no_gravity):
		#no_gravity = false
		
	if (Input.is_action_pressed("No_Gravity")):
		# Set no_gravity to true, start decrementing the counter
		# if the counter is zero, set it back to true and start incrementing the counter
		
		if (no_gravity_counter > 0):
			no_gravity = true
			no_gravity_counter -= DECREMENT_SPEED
		else:
			no_gravity = false
		
		
		#if (no_gravity == false && no_gravity_counter > 0):
			#no_gravity = true
			#
		#
		#if (no_gravity_counter > 0):
			#no_gravity_counter -= DECREMENT_SPEED
		#else:
			#no_gravity = false
			#
		#
		#no_gravity = true
	#elif (no_gravity == true):
		#no_gravity = false
	else:
		if (no_gravity):
			no_gravity = false
			
			
		if (no_gravity_counter < 100):
			no_gravity_counter += INCREMENT_SPEED
		
		
	if (Input.is_action_pressed("Zoom_Out")):
		zoom_out = true
	elif (zoom_out == true):
		zoom_out = false
		
	
	
