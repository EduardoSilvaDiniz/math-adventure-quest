extends Node2D

const PRE_GATE = preload("res://scene/gate.tscn")

func del_gate():
	queue_free()
