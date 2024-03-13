extends CharacterBody2D
class_name Enemy

@onready var anim_sprite = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@onready var health_bar = $"ui/health-bar"

var DEFAULT_SPEED #= 20
var speed_mult = 1

var target
var path
var screen_size : Vector2

var navigating = false
var nav_agent : AStarGrid2D

var health = 100
var death_deterent = 1

func _ready():
	screen_size = GlobalVariables.get_screen_size()
	target = get_nearest_edge()
	update_health_bar()

#func random_target(): #instead calculate nearest edge
#	var random_loc = Vector2(randf_range(1,screen_size.x),
#							randf_range(1,screen_size.y))
#	var target_edge = random_loc * screen_borders[randi_range(0,screen_borders.size()-1)]
#	target_edge = target_edge.clamp(Vector2.ZERO, screen_size)
#	return target_edge

func get_nearest_edge(): #instead calculate nearest edge
	var target_edge
	
	var distance_to_right_border = screen_size.x - position.x
	var distance_to_bottom_border = screen_size.y - position.y
	
	match min(position.x, position.y, distance_to_right_border, distance_to_bottom_border):
		position.x:
			target_edge = Vector2(-32, position.y)
		position.y:
			target_edge = Vector2(position.x, -32)
		distance_to_right_border:
			target_edge = Vector2(screen_size.x + 32, position.y)
		distance_to_bottom_border:
			target_edge = Vector2(position.x, screen_size.y + 32)
	return target_edge

#func begin_navigation(new_target):
#	target = new_target
#	path = GlobalVariables.get_navpath(global_position, target)

func start_navigation(new_path):
	new_path.remove_at(0)
	path = new_path
	navigating = true

func get_navpath():
	return path

func set_speed_mult(mult : float):
	speed_mult = mult
	anim_sprite.speed_scale = mult

func get_next_position():
	if len(path) > 1:
		if abs(position-path[0]).floor() == Vector2.ZERO:
			if nav_agent.get_point_weight_scale(path[0]/32) < 5:
				set_speed_mult(1.3)
			else:
				set_speed_mult(1)
			#print('n',nav_agent.get_point_weight_scale(path[0]/32))
			path.remove_at(0)
		return path[0]

func damage(d):
	health -= d
	update_health_bar()
	anim_player.play("damaged")
	if health < 0:
		var death_pos = get_global_position()/32
		nav_agent.set_point_weight_scale(death_pos, 
					nav_agent.get_point_weight_scale(death_pos) + death_deterent
					)
		queue_free()

func update_health_bar():
	var new_size = 3 * round(health/10)
	health_bar.size.x = new_size
	health_bar.position.x = -new_size/2

func _physics_process(_delta):
	velocity.x = 0
	velocity.y = 0
	
	if not navigating:
		return

	var next_pos = get_next_position()
	if not next_pos:
		queue_free() #begin_navigation(random_target())
		return
	elif position.x < 0 or position.y < 0 or position.x > screen_size.x or position.y > screen_size.y:
		queue_free()
		return
	var direction = (next_pos-position).floor()
	if direction.x > 0:
		velocity.x = DEFAULT_SPEED * speed_mult
		anim_sprite.play('left')
		anim_sprite.flip_h = true
	elif direction.x < 0:
		velocity.x = -DEFAULT_SPEED * speed_mult
		anim_sprite.play('left')
		anim_sprite.flip_h = false
	elif direction.y > 0:
		velocity.y = DEFAULT_SPEED * speed_mult
		anim_sprite.play('down')
	elif direction.y < 0:
		velocity.y = -DEFAULT_SPEED * speed_mult
		anim_sprite.play('up')
	#velocity = direction.normalized() * SPEED
	move_and_slide()
