extends Node2D
class_name Tower

@onready var placing_grid = $rotation_point/Placing_grid

var target
var disabled = true
var attack_weight_area : Array[Rect2i] = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]
var attack_weight_transform : Callable = func (x): return x-5

var offset = Vector2(24,24)

var can_attack = true

# Called when the node enters the scene tree for the first time.
func _ready():
	placing_grid.visible = true

func get_attack_weight_area():
	return attack_weight_area[0]

func get_attack_weight():
	return attack_weight_transform

func place():
	placing_grid.visible = false
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
