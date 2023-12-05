extends Node2D

@onready var sound := $music as AudioStreamPlayer

func _on_music_finished():
	sound.play()
