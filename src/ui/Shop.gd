extends Control

func _ready():
	visible = false

func open():
	visible = true
	#resume_button.grab_focus()

func close():
	visible = false

