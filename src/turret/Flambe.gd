extends Turret

@onready var flame_particles_left = $rotation_point/gun_rotation/FlameParticlesLeft
@onready var flame_particles_right = $rotation_point/gun_rotation/FlameParticlesRight

func _ready():
	tower_type = GlobalVariables.TOWERS.FLAMBE
	attack_weight_area = [Rect2i(0,0,3,1),Rect2i(0,0,1,3),Rect2i(0,0,3,1),Rect2i(0,0,1,3)]
	damage = 10
	attack_collision.monitoring = false
	range_indicator.visible = true
	side_panel.open(self)

func attack_process(_delta):
	var i = 0
	
	if can_attack:
		for x in attack_collision.get_overlapping_bodies():
			if x is Enemy and is_instance_valid(x):
				i += 1
				
				x.damage(damage)
				attack_cooldown.start()
				flame_particles_left.set_emitting(true)
				flame_particles_right.set_emitting(true)
				attack_audio.play()
				can_attack = false
				
				if i > 12:
					return
