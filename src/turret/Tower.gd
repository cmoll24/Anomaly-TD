extends Node2D
class_name Tower

@onready var range_indicator = $rotation_point/Range_indicator

#var target
var disabled = true
var attack_weight_area : Array[Rect2i] = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]

var offset = Vector2(16,16)

var can_attack = true

var tower_type : GlobalVariables.TOWERS

var side_panel

func add_weight_transform(x, loc, pheromones_grid):
	if not loc in pheromones_grid:
		return x + 5
	else:
		pheromones_grid[loc][1] += 5
		return x

func remove_weight_transform(x, loc, pheromones_grid):
	if not loc in pheromones_grid:
		return x - 5
	else:
		pheromones_grid[loc][1] -= 5
		return x
	
# Called when the node enters the scene tree for the first time.
func _ready():
	range_indicator.visible = true
	side_panel.open(tower_type)

func get_attack_weight_area():
	return attack_weight_area[0]

func get_attack_weight():
	return add_weight_transform

func get_undo_weight():
	return remove_weight_transform

func get_cost():
	return GlobalVariables.stats[tower_type]['cost']

func place():
	range_indicator.visible = false
	range_indicator.z_index = -1
	disabled = false
	side_panel.close()

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
		side_panel.open(self)

func _unhandled_input(event):
	if not disabled and event.is_action_pressed("select"):
		range_indicator.visible = false
		side_panel.close()

func delete_tower():
	range_indicator.visible = false
	side_panel.close()
	self.queue_free()
