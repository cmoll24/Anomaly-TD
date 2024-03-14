extends Turret

@onready var attacking_duration = $attacking_duration

func _ready():
	tower_type = GlobalVariables.TOWERS.LASER
	attack_weight_area = [Rect2i(0,-3,1,4),Rect2i(0,0,4,1),Rect2i(0,0,1,4),Rect2i(-3,0,4,1)]
	attack_collision.monitoring = false
	attack.visible = false
	range_indicator.visible = true
	side_panel.open(tower_type)

func attack_process(delta):
	if can_attack and target and is_instance_valid(target):
		attack.visible = true
		attack.size.y = get_global_position().distance_to(target.global_position+Vector2(-16,-16))
		target.damage(15*delta)
		gun_anim.play("attack1")
		if attacking_duration.is_stopped():
			attacking_duration.start()
	else:
		attack.visible = false

func _on_attacking_duration_timeout():
	can_attack = false
	attack_cooldown.start()
	gun_anim.play("idle")
