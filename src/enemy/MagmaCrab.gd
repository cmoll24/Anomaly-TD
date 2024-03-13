extends Enemy

func _ready():
	DEFAULT_SPEED = 35
	health = 100
	death_deterent = 2
	coin_bonus = 15
	
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()
