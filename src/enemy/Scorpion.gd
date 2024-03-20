extends Enemy

func _ready():
	DEFAULT_SPEED = 20
	health = 150
	death_deterent = 1
	coin_bonus = 10
	
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()
