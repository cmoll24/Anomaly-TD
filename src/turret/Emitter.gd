extends Tower

func _ready():
	#attack_weight_area = [Rect2i(-2,-2,5,5),Rect2i(-2,-1,5,5),Rect2i(-2,-2,5,5),Rect2i(-2,-2,5,5)]
	attack_weight_transform = func (_x): return 1


