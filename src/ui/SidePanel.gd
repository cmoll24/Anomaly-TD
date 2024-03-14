extends Control

@onready var tower_name = $VBoxContainer/name
@onready var description = $VBoxContainer/description

func _ready():
	visible = false

func open(tower_type : GlobalVariables.TOWERS):
	visible = true
	tower_name.text = GlobalVariables.stats[tower_type]['name']
	description.text = GlobalVariables.stats[tower_type]['description']

func close():
	visible = false
