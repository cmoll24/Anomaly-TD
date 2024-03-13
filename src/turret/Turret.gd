extends Tower
class_name Turret

@onready var rotation_point = $rotation_point
@onready var gun_rotation = $rotation_point/gun_rotation
@onready var attack_collision = $rotation_point/attack_collision
@onready var attack = $rotation_point/gun_rotation/attack
@onready var attack_cooldown = $attack_cooldown
@onready var gun_anim = $rotation_point/gun_rotation/Gun

# Called when the node enters the scene tree for the first time.
func _ready():
	range_indicator.visible = true
	attack_weight_area = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]
	attack_collision.monitoring = false
	attack.visible = false

func get_attack_weight_area():
	var direction = int(rad_to_deg(rotation_point.rotation)/90)%4
	return attack_weight_area[direction]

func place():
	attack_collision.monitoring = true
	range_indicator.visible = false
	disabled = false
	range_indicator.z_index = -1

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


func attack_process(delta):
	if target and is_instance_valid(target):
		var target_direction = (get_global_position()+offset).angle_to_point(target.global_position+Vector2(8,8)) + deg_to_rad(90) - rotation_point.rotation
		gun_rotation.rotation = lerp_angle(gun_rotation.rotation, target_direction, 5*delta)
		
		#print(abs(angle_difference(rotation_point.rotation,target_direction)))
		if can_attack and abs(angle_difference(gun_rotation.rotation,target_direction)) < 0.2:
			#attack.visible = true
			target.damage(3)
			attack_cooldown.start()
			gun_anim.play("attack1")
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

