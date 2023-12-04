extends CharacterBody2D
class_name button

@onready var animation := $sprite as AnimatedSprite2D # variavel para manipular a sprite do player

func changeSprite(sprite):
	$sprite.play(sprite)
