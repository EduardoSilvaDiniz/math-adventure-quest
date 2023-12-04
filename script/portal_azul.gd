extends CharacterBody2D

func teleporta():
	if Global.obj == get_node("portal_azul_1"):
		get_parent().get_node("player").position = get_parent().get_node("portal_azul_2").position
	else:
		get_parent().get_node("player").position = get_parent().get_node("portal_azul_1").position
