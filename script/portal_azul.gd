extends CharacterBody2D

var portal_1
var portal_2
var portal_3
var portal_4
@onready var sound := $sound as AudioStreamPlayer2D
func _ready():
	portal_1 = get_parent().get_node("portal_azul_1/Area2D")
	portal_2 = get_parent().get_node("portal_azul_2/Area2D")
	portal_3 = get_parent().get_node("portal_azul_3/Area2D")
	portal_4 = get_parent().get_node("portal_azul_4/Area2D")

func teleporta():
	match Global.obj:
		portal_1:
			sound.play()
			get_parent().get_node("player").position = get_parent().get_node("portal_azul_2").position
		portal_2:
			sound.play()
			get_parent().get_node("player").position = get_parent().get_node("portal_azul_1").position
		portal_3:
			sound.play()
			get_parent().get_node("player").position = get_parent().get_node("portal_azul_4").position
		portal_4:
			sound.play()
			get_parent().get_node("player").position = get_parent().get_node("portal_azul_3").position
