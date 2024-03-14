extends Control


func _on_level_1_pressed():
	var _error = get_tree().change_scene_to_file("res://src/level1.tscn")


func _on_level_2_pressed():
	var _error = get_tree().change_scene_to_file("res://src/level2.tscn")
