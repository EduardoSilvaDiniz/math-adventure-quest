#extends CharacterBody2D
class_name button_floor


@onready var boxdetect := $boxdetect as RayCast2D

func _physics_process(delta):
	if collision_box():
		print("colidiu")
		#press()

#func press():
#	animation.play("enable")

func collision_box():
	return boxdetect.is_colliding()
	
