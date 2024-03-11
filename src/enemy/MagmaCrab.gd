extends Enemy

func _ready():
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	DEFAULT_SPEED = 35
