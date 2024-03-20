extends Turret

func _ready():
	tower_type = GlobalVariables.TOWERS.LASER
	attack_weight_area = [Rect2i(0,0,3,1),Rect2i(0,0,1,3),Rect2i(0,0,3,1),Rect2i(0,0,1,3)]
	damage = 10
	attack_collision.monitoring = false
	attack.visible = false
	range_indicator.visible = true
	side_panel.open(self)
	
func attack_process(_delta):
	if can_attack:
		for x in attack_collision.get_overlapping_bodies():
			if x is Enemy and is_instance_valid(x):
				x.damage(damage)
				attack_cooldown.start()
				gun_anim.play("attack1")
				attack_audio.play()
				can_attack = false
