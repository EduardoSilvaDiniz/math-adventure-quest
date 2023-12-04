extends Node2D

@onready var boxdetect := $boxdetect as RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collision_box():
		print("colidiu")


func collision_box():
	return boxdetect.is_colliding()
