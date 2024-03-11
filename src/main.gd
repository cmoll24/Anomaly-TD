extends Control

@onready var unit_tree : Node2D = $Ysort/creatures
@onready var tower_tree : Node2D = $Ysort/towers
@onready var scorpion = load("res://src/enemy/scorpion.tscn")
@onready var turret = load("res://src/turret/Turret.tscn")
@onready var terrain : TileMap = $Ysort/Terrain
@onready var towers : TileMap = $Ysort/Towers32x32
@onready var timer = $Timer

@onready var academy = $Academy

var screen_size : Vector2
var grid_screen : Rect2i #visible grid area
var place_area : Rect2 #area where you can place turrets
var astargrid : AStarGrid2D

var enemy_path_start : Vector2
var enemy_path_end : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_path_start = Vector2(academy.position/32)
	enemy_path_end = Vector2(-2,-2)
	
	screen_size = GlobalVariables.get_screen_size()
	
	grid_screen = Rect2i(-1,-1,int(screen_size.x/32)+2,int(screen_size.y/32)+2)
	place_area = Rect2(Vector2(0,0),(grid_screen.size-Vector2i(2,2))*32)
	print(grid_screen)

	astargrid = AStarGrid2D.new()
	astargrid.set_offset(Vector2(16,16))
	astargrid.region = Rect2i(grid_screen.position - Vector2i(1,1), grid_screen.size + Vector2i(2,2))
	astargrid.cell_size = GlobalVariables.GRID_CELL_SIZE
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astargrid.update()
	set_terrain()
	
	spawn_unit(enemy_path_start*32)
	timer.start()

func set_terrain():
	astargrid.set_point_solid(enemy_path_start)
	
	astargrid.fill_weight_scale_region(astargrid.region, 0)
	astargrid.fill_weight_scale_region(grid_screen, 5)#max(grid_screen.size.x,grid_screen.size.y)+20)
	print(terrain.get_used_rect())
	print(Rect2i(0,0,int(screen_size.x/16),int(screen_size.y/16)))
	
	for i in range(grid_screen.size.x-2):
		for j in range(grid_screen.size.y-2):
			var new_loc = Vector2i(i,j)
			if terrain.get_cell_tile_data(0, new_loc*2).get_terrain() == 1:
				#print(astargrid.get_point_weight_scale(new_loc))
				astargrid.set_point_weight_scale(new_loc,  astargrid.get_point_weight_scale(new_loc) - 2)

func create_navpath(start):
	#print(start/32,end/32)
	var path = astargrid.get_point_path(start/32,enemy_path_end)
	#print(path)
	return path

func set_nav_collison(loc : Vector2):
	astargrid.set_point_solid(loc)
	
	if create_navpath(enemy_path_start*32).is_empty():
		astargrid.set_point_solid(loc, false)
		return false
	
	var target_range = 1
	for i in range(-target_range,target_range+1):
		for j in range(-target_range,target_range+1):
			var new_loc = loc + Vector2(i,j)
			if astargrid.is_in_bounds(new_loc.x, new_loc.y):
				astargrid.set_point_weight_scale(new_loc, astargrid.get_point_weight_scale(new_loc) + 5)
	return true

func _draw():
	'''
	for child in unit_tree.get_children():
		if child is Enemy:
			var path = child.get_navpath()
			if path and len(path) > 2:
				self.draw_polyline(path,Color.RED,2)
	'''
	var mouse_pos = get_global_mouse_position()
	if place_area.has_point(mouse_pos):
		draw_rect(Rect2((mouse_pos/32).floor()*32,Vector2(32,32)),Color(1,0,0,0.5))

	#draw_rect(place_area,Color(0,0,1,0.5))
	'''
	for i in range(grid_screen.size.x-2):
		for j in range(grid_screen.size.y-2):
			var cell_weight = astargrid.get_point_weight_scale(Vector2i(i,j))
			draw_rect(Rect2(Vector2(i,j)*32,Vector2(32,32)),
			Color(0,0,cell_weight/50,
			cell_weight/50
			))
	'''

func _process(_delta):
	queue_redraw()

#func get_random_loc():
#	return Vector2(randi_range(1,screen_size.x),
#				   randi_range(1,screen_size.y))

func _on_timer_timeout():
	spawn_unit(enemy_path_start*32)#get_random_loc())#Vector2(screen_size.x/2,screen_size.y/2))
	timer.start()

func spawn_unit(pos):
	var enemy = scorpion.instantiate()
	enemy.set_position(pos.snapped(Vector2(GlobalVariables.GRID_CELL_SIZE)) + Vector2(16,16))
	unit_tree.add_child(enemy)
	#print(create_navpath(enemy.position,enemy.target))
	enemy.start_navigation(create_navpath(enemy.position))
	enemy.nav_agent = astargrid

func place_turret(pos):
	var grid_pos = (pos / Vector2(32,32)).floor()
	
	var grid_pos2i = Vector2i(grid_pos)
	if not astargrid.is_point_solid(grid_pos2i):
		
		if set_nav_collison(grid_pos) == false:
			return
		
		var t = turret.instantiate()
		t.set_position(grid_pos*Vector2(32,32))
		tower_tree.add_child(t)
		
		print(grid_pos2i)
		#towers.set_cells_terrain_connect(0, [grid_pos2i], 0, 0)
	
	for child in unit_tree.get_children():
		if child is Enemy:
			child.start_navigation(create_navpath(child.position))

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		print('click')
		var mouse_pos = get_global_mouse_position()
		if place_area.has_point(mouse_pos):
			place_turret(mouse_pos)
