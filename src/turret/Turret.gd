extends Node2D
class_name Turret

@onready var rotation_point = $rotation_point
@onready var gun_rotation = $rotation_point/gun_rotation
@onready var attack_collision = $rotation_point/attack_collision
@onready var attack = $rotation_point/gun_rotation/attack
@onready var placing_grid = $rotation_point/Placing_grid
@onready var attack_cooldown = $attack_cooldown
var target
var disabled = true
var attack_range : Array[Rect2i] = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]

var offset = Vector2(24,24)

var can_attack = true

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_collision.monitoring = false
	attack.visible = false
	placing_grid.visible = true

func get_attack_range():
	var direction = int(rad_to_deg(rotation_point.rotation)/90)%4
	return attack_range[direction]

func place():
	attack_collision.monitoring = true
	placing_grid.visible = false
	disabled = false

func calculate_closest_target():
	var closest_target = null
	for x in attack_collision.get_overlapping_bodies():
		if x is Enemy:
			if closest_target and is_instance_valid(closest_target):
				if position.distance_squared_to(x.global_position) < position.distance_squared_to(closest_target.global_position):
					closest_target = x
			else:
				closest_target = x
	return closest_target

func _process(delta): #make it slowaly turn, not instant
	if disabled:
		position = (get_global_mouse_position()/32).floor()*32
		return
	attack_process(delta)

func attack_process(delta):
	if target and is_instance_valid(target):
		var target_direction = (get_global_position()+offset).angle_to_point(target.global_position) + deg_to_rad(90) - rotation_point.rotation
		gun_rotation.rotation = lerp_angle(gun_rotation.rotation, target_direction, 5*delta)
		
		#print(abs(angle_difference(rotation_point.rotation,target_direction)))
		if can_attack and abs(angle_difference(gun_rotation.rotation,target_direction)) < 0.2:
			attack.visible = true
			target.damage(3)
			attack_cooldown.start()
			can_attack = false
		else:
			attack.visible = false
	else:
		attack.visible = false

func rotate_turret():
	rotation_point.rotation += deg_to_rad(90)

func _on_attack_collision_body_entered(_body):
	target = calculate_closest_target()

func _on_attack_collision_body_exited(_body):
	target = calculate_closest_target()

func _on_attack_cooldown_timeout():
	can_attack = true
