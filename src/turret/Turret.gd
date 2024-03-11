extends Node2D

@onready var rotation_point = $rotation_point
@onready var attack_range = $attack_range
@onready var attack = $rotation_point/attack
var target

var offset = Vector2(24,24)

# Called when the node enters the scene tree for the first time.
func _ready():
	attack.visible = false

func calculate_closest_target():
	var closest_target = null
	for x in attack_range.get_overlapping_bodies():
		if x is Enemy:
			if closest_target and is_instance_valid(closest_target):
				if position.distance_squared_to(x.global_position) < position.distance_squared_to(closest_target.global_position):
					closest_target = x
			else:
				closest_target = x
	return closest_target

func _process(_delta): #make it slowaly turn, not instant
	if target and is_instance_valid(target):
		var target_direction = (get_global_position()+offset).angle_to_point(target.global_position) + deg_to_rad(90)
		rotation_point.rotation = lerp_angle(rotation_point.rotation, target_direction, 0.05)
		
		#print(abs(angle_difference(rotation_point.rotation,target_direction)))
		if abs(angle_difference(rotation_point.rotation,target_direction)) < 0.2:
			attack.visible = true
		else:
			attack.visible = false
	else:
		attack.visible = false

func _on_area_2d_body_entered(_body):
	target = calculate_closest_target()

func _on_attack_range_body_exited(_body):
	target = calculate_closest_target()
