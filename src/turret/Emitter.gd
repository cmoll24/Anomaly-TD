extends Tower

func add_weight_transform(x, loc, pheromones_grid): 
	if loc not in pheromones_grid:
		pheromones_grid[loc] = [1,x] #save actual_value
		return 1
	else: #there is already  a emitter here
		pheromones_grid[loc][0] += 1
		return x

func remove_weight_transform(x, loc, pheromones_grid):
	pheromones_grid[loc][0] -= 1
	if pheromones_grid[loc][0] <= 0:
		var actual_value = pheromones_grid[loc][1]
		pheromones_grid.erase(loc)
		return actual_value
	return x

func _ready():
	#attack_weight_area = [Rect2i(-2,-2,5,5),Rect2i(-2,-1,5,5),Rect2i(-2,-2,5,5),Rect2i(-2,-2,5,5)]
	tower_type = GlobalVariables.TOWERS.EMITTER
	range_indicator.visible = true
	side_panel.open(self)
