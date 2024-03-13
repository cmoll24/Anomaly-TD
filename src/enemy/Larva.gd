extends Enemy

func _ready():
	DEFAULT_SPEED = 10
	health = 35
	death_deterent = 0
	
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()
