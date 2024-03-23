extends Node
class_name EnemyWaves

@onready var larva = load("res://src/enemy/Larva.tscn")
@onready var scorpion = load("res://src/enemy/Scorpion.tscn")
@onready var magma_crab = load("res://src/enemy/MagmaCrab.tscn")
@onready var beetle = load("res://src/enemy/Beetle.tscn")

@onready var timer = $Timer

var n_round = 0
var waves : Array
var current_waves #Array[Array[enemies],time]
var timing = 1

signal spawn_wave(enemy_type)
signal waves_over()

func _ready():
	waves = [1,0,0,0]
	
	start_waves()

func add_wave(enemy_type):
	waves[enemy_type] += 1

func remove_wave(enemy_type):
	waves[enemy_type] -= 1

func start_waves():
	n_round += 1
	var enemies = []
	for enemy_type in range(len(waves)):
		for i in range(waves[enemy_type]):
			enemies.append(enemy_type)
	var n_per_wave = max(len(enemies)/5,1)
	enemies.shuffle()
	
	current_waves = []
	
	while len(enemies) > 0:
		var wave = []
		for x in range(n_per_wave):
			var next_enemy = enemies.pop_front()
			if next_enemy != null:
				wave.append(next_enemy)
		current_waves.append([wave,randi_range(5,5+min(n_per_wave/2,15))])
	timer.start(max(30 - n_per_wave, 5))

func _on_timer_timeout():
	if len(current_waves) > 0:
		var next_wave = current_waves[0]
		if next_wave == null:
			end_waves()
			return
		
		var enemy_type = next_wave[0].pop_front()
		emit_signal("spawn_wave",enemy_type)
		if len(next_wave[0]) == 0:
			current_waves.pop_front()
			if len(current_waves) > 0:
				timer.start(next_wave[1])
			else:
				end_waves()
		else:
			timer.start(max(
				lerpf(1,
					  0.2,
					  len(next_wave[0])/20.0), 
				0.2)
				)

func end_waves():
	emit_signal("waves_over")
	timer.stop()

func get_waves_left():
	return len(current_waves)
