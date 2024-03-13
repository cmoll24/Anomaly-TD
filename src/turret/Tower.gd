extends Node2D
class_name Tower

@onready var range_indicator = $rotation_point/Range_indicator

var target
var disabled = true
var attack_weight_area : Array[Rect2i] = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]
var attack_weight_transform : Callable = func (x, _loc, _pheromones_grid): return x + 5

var offset = Vector2(24,24)

var can_attack = true

var gbv_name : GlobalVariables.TOWERS

# Called when the node enters the scene tree for the first time.
func _ready():
	range_indicator.visible = true

func get_attack_weight_area():
	return attack_weight_area[0]

func get_attack_weight():
	return attack_weight_transform

func get_cost():
	return GlobalVariables.stats[gbv_name]['cost']

func place():
	range_indicator.visible = false
	range_indicator.z_index = -1
	disabled = false

func _process(delta): #make it slowaly turn, not instant
	if disabled:
		position = (get_global_mouse_position()/32).floor()*32
		return
	attack_process(delta)

func attack_process(_delta):
	pass

func rotate_turret():
	pass

func _on_attack_collision_body_entered(_body):
	pass

func _on_attack_collision_body_exited(_body):
	pass

func _on_attack_cooldown_timeout():
	can_attack = true
	
func _on_click_area_input_event(_viewport, event, _shape_idx):
	if not disabled and event.is_action_pressed("select"):
		range_indicator.visible = true

func _input(event):
	if not disabled and event.is_action_pressed("select"):
		range_indicator.visible = false
