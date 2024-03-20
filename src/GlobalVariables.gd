extends Node

#const SAVE_DIR = "user://saves/"

#var save_path = SAVE_DIR + "save.json"
#var opt_path = SAVE_DIR + "options.json"

var aspect_ratio = Vector2i(16,9)
var viewport_size : Vector2
var GRID_CELL_SIZE = Vector2i(32,32)

var coins : int = 0
var starting_coins = 500000
var player_health = 20

var current_map_path

enum TOWERS {
	TURRET,
	EMITTER,
	LASER,
	FLAMBE
}

enum ENEMIES {
	LARVA,
	SCORPION,
	ROACH,
	BEETLE
}

var stats = {
	TOWERS.TURRET : {'path' : "res://src/turret/Turret.tscn", 'cost' : 15, 'name' : 'Turret', 
	'description' : "Basic turret shoots at one enemy at a time.\n\nDeals 3 damage and fires 6 times per second"},
	TOWERS.EMITTER : {'path' : "res://src/turret/Emitter.tscn", 'cost' : 10, 'name' : 'Emitter',
	'description' : "Pheromone emitter attracts bugs towards it's area."},
	TOWERS.LASER : {'path' : "res://src/turret/Laser.tscn", 'cost' : 30, 'name' : 'Laser',
	'description' : "Powerful laser that deals damage over time in a straight line to one target.\n\nDeals 150 damage over 10s and cools down for 5s"},
	TOWERS.FLAMBE : {'path' : "res://src/turret/Flambe.tscn", 'cost' : 1, 'name' : 'Flambé',
	'description' : "Flambé those bugs!"}
	
	}

var enemy_stats = {
	ENEMIES.LARVA : {'path' : "res://src/enemy/Larva.tscn", 'cost' : 5, 'name' : 'Larva'},
	ENEMIES.SCORPION : {'path' : "res://src/enemy/Scorpion.tscn", 'cost' : 10, 'name' : 'Scorpion'},
	ENEMIES.ROACH : {'path' : "res://src/enemy/MagmaCrab.tscn", 'cost' : 15, 'name' : 'Roach'},
	ENEMIES.BEETLE : {'path' : "res://src/enemy/Beetle.tscn", 'cost' : 50, 'name' : 'Beetle'}
}

var highscore = 0
var current_score = 0

signal lost_game

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	rescale_window()

func set_coins(init_val):
	coins = init_val

func change_coins(val):
	coins = max(coins+val,0)

func get_coins():
	return coins

func reset_game_values():
	current_score = 0
	set_coins(starting_coins)
	player_health = 20

func add_score(val):
	current_score += val

func get_highscore():
	return highscore

func update_highscore():
	highscore = max(current_score,highscore)

func damage_player(val):
	player_health -= val
	Engine.time_scale = 1
	if player_health <= 0:
		emit_signal('lost_game')
		update_highscore()

func get_player_health():
	return player_health

func get_screen_size() -> Vector2:
	return viewport_size

func set_current_map(tile_map_path):
	current_map_path = tile_map_path

func rescale_window():
	var screen_border = Vector2i(100,100)
	#var window_size = DisplayServer.window_get_size()
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_min_size(aspect_ratio * 20)
	
	var screen_aspect = (screen_size - screen_border) / aspect_ratio
	var mult = min(screen_aspect.x,screen_aspect.y)
	var max_size = aspect_ratio * mult
	
	DisplayServer.window_set_size(max_size)
	#center the window
	DisplayServer.window_set_position((screen_size / 2) - (max_size / 2))

func set_fullscreen(fullscreen : bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			set_fullscreen(false)
		else:
			set_fullscreen(true)
		get_viewport().set_input_as_handled()
