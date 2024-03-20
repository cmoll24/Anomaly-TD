extends Control

@onready var tower_name = $VBoxContainer/name
@onready var description = $VBoxContainer/description
@onready var sell_button = $VBoxContainer/sell

signal remove_weight(loc : Vector2, undo_weight : Callable, attack_area : Rect2i)

var current_tower = null

func _ready():
	visible = false
	sell_button.visible = false

func open(tower : Tower):#tower_type : GlobalVariables.TOWERS):
	if current_tower and is_instance_valid(current_tower):
		current_tower.range_indicator.visible = false
	close()
	visible = true
	current_tower = tower
	
	tower_name.text = GlobalVariables.stats[current_tower.tower_type]['name']
	description.text = GlobalVariables.stats[current_tower.tower_type]['description']
	
	if not current_tower.disabled:
		sell_button.visible = true
		sell_button.text = "Sell for " + str(round(current_tower.get_cost() * 0.75))

func close():
	visible = false
	sell_button.visible = false

func _on_sell_pressed():
	emit_signal("remove_weight", current_tower.position/32, current_tower.get_undo_weight(), current_tower.get_attack_weight_area())
	GlobalVariables.change_coins(round(current_tower.get_cost() * 0.75))
	current_tower.queue_free()
	self.close()
