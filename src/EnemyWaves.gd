extends Node
class_name EnemyWaves

@onready var larva = load("res://src/enemy/Larva.tscn")
@onready var scorpion = load("res://src/enemy/Scorpion.tscn")
@onready var magma_crab = load("res://src/enemy/MagmaCrab.tscn")
@onready var beetle = load("res://src/enemy/Beetle.tscn")

@onready var timer = $Timer

var waves : Array
var current_waves #Array[Array[enemies],time]

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
	var enemies = []
	for enemy_type in range(len(waves)):
		for i in range(waves[enemy_type]):
			enemies.append(enemy_type)
	var n_per_wave = max(len(enemies)/10,1)
	enemies.shuffle()
	
	current_waves = []
	
	while len(enemies) > 0:
		var wave = []
		for x in range(n_per_wave):
			wave.append(enemies.pop_front())
		current_waves.append([wave,randi_range(5,5+min(n_per_wave,20))])
	timer.start(30)

func _on_timer_timeout():
	if len(current_waves) > 0:
		var next_wave = current_waves[0]
		if next_wave == null:
			end_waves()
			return
		
		if len(next_wave[0]) == 0:
			current_waves.pop_front()
			if len(current_waves) > 0:
				timer.start(next_wave[1])
			else:
				end_waves()
		else:
			var enemy_type = next_wave[0].pop_front()
			if enemy_type != null:
				emit_signal("spawn_wave",enemy_type)
				timer.start(1)

func end_waves():
	emit_signal("waves_over")
	timer.stop()

