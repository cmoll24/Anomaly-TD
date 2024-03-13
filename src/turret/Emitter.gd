extends Tower

func add_weight(_x, loc, pheromones_grid): 
	pheromones_grid.append(loc) 
	return 1

func _ready():
	#attack_weight_area = [Rect2i(-2,-2,5,5),Rect2i(-2,-1,5,5),Rect2i(-2,-2,5,5),Rect2i(-2,-2,5,5)]
	attack_weight_transform = add_weight
	range_indicator.visible = true
