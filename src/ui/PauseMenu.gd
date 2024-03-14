extends Control

@onready var resume_button = $VBoxContainer/Resume

@export var pause_tree : Control

signal resume

func _ready():
	visible = false

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
