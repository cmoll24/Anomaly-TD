extends Turret

@onready var attacking_duration = $attacking_duration

func _ready():
	tower_type = GlobalVariables.TOWERS.LASER
	attack_weight_area = [Rect2i(0,-3,1,4),Rect2i(0,0,4,1),Rect2i(0,0,1,4),Rect2i(-3,0,4,1)]
	damage = 15
	attack_collision.monitoring = false
	attack.visible = false
	range_indicator.visible = true
	side_panel.open(self)
	

func attack_process(delta):
	var target = null
	if can_attack:
		target = calculate_closest_target()
	if can_attack and not attacking_duration.is_stopped():
			gun_anim.play("attack1")
	
	if can_attack and target and is_instance_valid(target):
		attack.visible = true
		attack.size.y = get_global_position().distance_to(target.global_position+Vector2(-16,-16))
		target.damage(damage*delta)
		if not attack_audio.playing:
			attack_audio.play()
		if attacking_duration.is_stopped():
			attacking_duration.start()
	else:
		attack.visible = false
		attack_audio.stop()

func _on_attacking_duration_timeout():
	can_attack = false
	attacking_duration.stop()
	attack_cooldown.start()
	gun_anim.play("idle")
