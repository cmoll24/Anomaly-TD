extends Enemy

func _ready():
	DEFAULT_SPEED = 10
	health = 600
	death_deterent = 30
	coin_bonus = 50
	
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()
