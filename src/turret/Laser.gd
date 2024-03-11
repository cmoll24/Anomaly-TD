extends Turret

func attack_process():
	if target and is_instance_valid(target):
		attack.visible = true
		attack.size.y = position.y - target.global_position.y + 16
	else:
		attack.visible = false
