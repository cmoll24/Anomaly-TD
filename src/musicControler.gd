extends Node

@onready var bass = $bass

#func _ready():
#	set_music_level(1)

#func _process(delta):
#	print(bass.get_playback_position())

func set_music_level(level, delta):
	var i = 1
	for track in get_children():
		if i <= level:
			track.volume_db = lerpf(track.volume_db, 0, 0.1 * delta)
		else:
			track.volume_db = lerpf(track.volume_db, -80, 0.01 * delta)
		#print(track.volume_db )
		i += 1

func fade_music(delta):
	for track in get_children():
		track.volume_db = lerpf(track.volume_db, -80, 0.1 * delta)
