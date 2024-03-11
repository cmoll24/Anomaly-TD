extends Node

#const SAVE_DIR = "user://saves/"

#var save_path = SAVE_DIR + "save.json"
#var opt_path = SAVE_DIR + "options.json"

var aspect_ratio = Vector2i(16,9)
var viewport_size : Vector2
var GRID_CELL_SIZE = Vector2i(32,32)

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	rescale_window()

func get_screen_size() -> Vector2:
	return viewport_size

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
