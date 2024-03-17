extends Control

@onready var highscore = $Highscore

func _ready():
	highscore.text += str(GlobalVariables.get_highscore())

func _on_level_1_pressed():
	GlobalVariables.set_current_map("res://src/tilemaps/level1_terrain.tscn")
	var _error = get_tree().change_scene_to_file("res://src/main.tscn")


func _on_level_2_pressed():
	GlobalVariables.set_current_map("res://src/tilemaps/level2_terrain.tscn")
	var _error = get_tree().change_scene_to_file("res://src/main.tscn")
