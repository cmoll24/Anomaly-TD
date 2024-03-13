extends Node
class_name EnemyWaves

@onready var larva = load("res://src/enemy/Larva.tscn")
@onready var scorpion = load("res://src/enemy/Scorpion.tscn")
@onready var magma_crab = load("res://src/enemy/MagmaCrab.tscn")

@onready var timer = $Timer

var waves : Array[Array]

signal spawn_wave(enemy_type)

func _ready():
	waves = [
			[larva,15],
			[larva,10],
			[larva,8],
			[larva,7],
			[larva,5],
			[larva,5],
			[larva,10],
			[scorpion,10],
			[larva,2],
			[larva,2],
			[larva,10],
			[scorpion,10],
			[scorpion,5],
			[scorpion,5],
			[scorpion,10],
			[scorpion,5],
			[scorpion,5],
			[scorpion,2],[larva,1],[larva,5],
			[scorpion,5],
			[scorpion,2],
			[scorpion,3],
			[scorpion,3],
			[scorpion,10],
			[magma_crab,10],
			[scorpion,3],
			[magma_crab,5],
			[larva,1],[larva,1],[larva,1],[larva,1],
			[scorpion,3],[magma_crab,3],[scorpion,3],[scorpion,3],[magma_crab,3],
			[larva,1],[larva,1],[larva,1],[larva,1],[scorpion,2],[magma_crab,2]
			]
	
	timer.start(15)

func get_next_wave():
	var next_wave = waves.pop_front()
	return next_wave if next_wave != null else [scorpion,1]


func _on_timer_timeout():
	var next_wave = waves.pop_front()
	if next_wave == null:
		next_wave = [scorpion,3]
	var enemy_type = next_wave[0]
	emit_signal("spawn_wave",enemy_type)
	timer.start(next_wave[1])
