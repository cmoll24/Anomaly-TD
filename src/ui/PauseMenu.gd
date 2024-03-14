extends Control

@onready var resume_button = $VBoxContainer/Resume
@onready var volume_slider = $VBoxContainer/Volume

@export var pause_tree : Control

signal resume

func _ready():
	visible = false
	
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))

func open():
	pause_tree.set_process_mode(PROCESS_MODE_DISABLED)
	visible = true
	resume_button.grab_focus()

func close():
	visible = false
	pause_tree.set_process_mode(PROCESS_MODE_INHERIT)
	print(pause_tree.get_process_mode())

func _on_resume_pressed():
	emit_signal("resume")
	close()

func _on_quit_pressed():
	get_tree().quit()
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause"):
		if pause_tree.get_process_mode() == PROCESS_MODE_INHERIT:
			open()
				
		elif pause_tree.get_process_mode() == PROCESS_MODE_DISABLED:
			close()
			
		get_viewport().set_input_as_handled()

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
