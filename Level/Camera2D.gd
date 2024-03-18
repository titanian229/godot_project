extends Camera2D

@export var zoom_out_ratio = 0.2
@onready var world = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (world.zoom_out || world.map_lock):
		# Change camera view
		zoom = Vector2(zoom_out_ratio, zoom_out_ratio)
	else:
		if (zoom.x != 1):
			zoom = Vector2(1, 1)
