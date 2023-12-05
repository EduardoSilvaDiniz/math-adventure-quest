extends CharacterBody2D

var button_1
@onready var sound := $sound as AudioStreamPlayer2D

func _ready():
	button_1 = get_parent().get_node("buttonWall_true/Area2D")

func fufando():
	match Global.obj:
		button_1:
			get_tree().call_group("gate", "del_gate5")
	sound.play()

func KeyE():
	if Global.obj == get_node("Area2D"):
		$keyE.text = "E"

func KeyE_hidden():
	$keyE.text = ""
