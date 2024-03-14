extends Control

@export var enemy_spawner : EnemyWaves
@onready var waves_txt = $VBoxContainer/Waves

func _ready():
	visible = false

func open():
	visible = true
	update_waves()
	#resume_button.grab_focus()

func close():
	visible = false

func _on_done_pressed():
	close()
	enemy_spawner.start_waves()

func update_waves():
	var txt = ''
	for enemy_type in range(len(enemy_spawner.waves)):
		txt += GlobalVariables.enemy_stats[enemy_type]['name'] + ' ' + str(enemy_spawner.waves[enemy_type]) + ', '
		#txt += GlobalVariables.enemy_stats[item[0]]['name'] + ', '
	waves_txt.text = txt
	

#Eggs

func add_enemy(enemy_type):
	var cost = GlobalVariables.enemy_stats[enemy_type]['cost']
	if GlobalVariables.get_coins() >= cost:
		GlobalVariables.change_coins(-cost)
		enemy_spawner.add_wave(enemy_type)
		update_waves()

func _on_larva_pressed():
	add_enemy(GlobalVariables.ENEMIES.LARVA)

func _on_scorpion_pressed():
	add_enemy(GlobalVariables.ENEMIES.SCORPION)

func _on_roach_pressed():
	add_enemy(GlobalVariables.ENEMIES.ROACH)

func _on_beetle_pressed():
	add_enemy(GlobalVariables.ENEMIES.BEETLE)
