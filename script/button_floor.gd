extends Node2D
#se quiser adicior mais botões certo só colocar button_*número* e depois colocar o local do botão no _ready()
var button_1
var button_2

func _ready():
	button_1 = get_parent().get_node("buttonFloor_true/Area2D")
	button_2 = get_parent().get_node("buttonFloor_true2/Area2D")

func _on_area_2d_area_entered(area):
	match area:
		button_1:
			get_parent().get_node("portal_azul_1").position = Vector2(1280, 400)
		button_2:
			print("botão certo")
		_:
			print('botão errado')

func _on_area_2d_area_exited(area):
	match area:
		button_1:
			get_parent().get_node("portal_azul_1").position = Vector2(721, 158)
		button_2:
			print("saiu do botão certo")
		_:
			print('saiu do botão errado')
