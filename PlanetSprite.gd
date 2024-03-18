extends Sprite2D

@onready var space_scene = get_node("/root/World/SpaceScene")
@export var mass = float(100)
# Called when the node enters the scene tree for the first time.
func _ready():
	#space_scene.bodies_in_space.append(self)
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
