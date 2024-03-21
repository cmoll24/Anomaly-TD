extends Tower
class_name Turret

@onready var rotation_point = $rotation_point
@onready var gun_rotation = $rotation_point/gun_rotation
@onready var attack_collision = $rotation_point/attack_collision
@onready var attack = $rotation_point/gun_rotation/attack
@onready var attack_cooldown = $attack_cooldown
@onready var gun_anim = $rotation_point/gun_rotation/Gun
@onready var attack_audio = $attack_audio

var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_type = GlobalVariables.TOWERS.TURRET
	range_indicator.visible = true
	attack_weight_area = [Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3),Rect2i(-1,-1,3,3)]
	attack_collision.monitoring = false
	attack.visible = false
	side_panel.open(self)

func get_attack_weight_area():
	var direction = int(rad_to_deg(rotation_point.rotation)/90)%4
	return attack_weight_area[direction]

func place():
	attack_collision.monitoring = true
	range_indicator.visible = false
	disabled = false
	range_indicator.z_index = -1
	side_panel.close()

func angle_to_target(target):
	return (get_global_position()+offset).angle_to_point(target.global_position) + deg_to_rad(90) - rotation_point.rotation

func calculate_closest_target_angle():
	var closest_target = null
	var closest_target_angle = null
	for x in attack_collision.get_overlapping_bodies():
		if x is Enemy:
			var angle = angle_to_target(x)
			#print(angle)
			if closest_target and is_instance_valid(closest_target):
				if abs(angle_difference(gun_rotation.rotation,angle)) < abs(angle_difference(gun_rotation.rotation,closest_target_angle)):
					closest_target = x
			else:
				closest_target = x
				closest_target_angle = angle
	return [closest_target, closest_target_angle]


func attack_process(delta):
	var new_target = calculate_closest_target_angle()
	var target = new_target[0]
	var target_angle = new_target[1]
	
	if target and is_instance_valid(target):
		gun_rotation.rotation = lerp_angle(gun_rotation.rotation, target_angle, 5*delta)
		
		#print(abs(angle_difference(rotation_point.rotation,target_direction)))
		if can_attack and abs(angle_difference(gun_rotation.rotation,target_angle)) < 0.2:
			#attack.visible = true
			target.damage(damage)
			attack_cooldown.start()
			gun_anim.play("attack1")
			attack_audio.play()
			can_attack = false

func rotate_turret():
	rotation_point.rotation += deg_to_rad(90)

func _on_attack_collision_body_entered(_body):
	#target = calculate_closest_target()
	pass

func _on_attack_collision_body_exited(_body):
	#target = calculate_closest_target()
	pass

