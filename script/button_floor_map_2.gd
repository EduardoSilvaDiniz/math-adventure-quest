extends Node2D
#se quiser adicior mais botões certo só colocar button_*número* e depois colocar o local do botão no _ready()
var button_1
var button_2
var button_3
var button_4


@onready var sound := $sound as AudioStreamPlayer2D
func _ready():
	button_1 = get_parent().get_node("buttonFloor_true/Area2D")
	button_2 = get_parent().get_node("buttonFloor_true2/Area2D")
	button_3 = get_parent().get_node("buttonFloor_true3/Area2D")
	button_4 = get_parent().get_node("buttonFloor_false3/Area2D")

func _on_area_2d_area_entered(area):
	match area:
		button_1:
			get_tree().call_group("gate", "del_gate")
		button_2:
			get_tree().call_group("gate", "del_gate2")
		button_3:
			get_tree().call_group("gate", "del_gate3")
		button_4:
			get_tree().call_group("gate", "del_gate4")
	sound.play()
