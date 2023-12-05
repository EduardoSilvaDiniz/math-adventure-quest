extends CharacterBody2D

var button_1
@onready var sound := $sound as AudioStreamPlayer2D

func _ready():
	button_1 = get_parent().get_node("buttonWall_true/Area2D")

func fufando():
	match Global.obj:
		button_1:
			print("funcionando 1")
	sound.play()
