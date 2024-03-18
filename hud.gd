extends CanvasLayer

@onready var progress_bar = $ProgressBar
@onready var jump_timer = $JumpTimer
@onready var rich_text_label = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("/root/World/SpaceScene/PlayerCat")
	jump_timer.max_value = player.debounce_jump_period


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var world = get_node("/root/World")
	progress_bar.value = world.no_gravity_counter
	
	var player = get_node("/root/World/SpaceScene/PlayerCat")
	
	jump_timer.value = player.debounce_jump_timer.time_left
	
	if (player.warp_target != null):
		if (player.debounce_warpto_timer.time_left > 0):
			rich_text_label.text = "Warp Target: " + player.warp_target.name + " " + str(round(player.debounce_warpto_timer.time_left * 100)/100)
		else:
			rich_text_label.text = "Warp Target: " + player.warp_target.name
			
	elif (len(rich_text_label.text) > 0):
		rich_text_label.text = ""
		
	#if (jump_timer.value > 0):
		#jump_
