extends Enemy

func _ready():
	DEFAULT_SPEED = 10
	health = 30
	death_deterent = 0
	coin_bonus = 5
	
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()
