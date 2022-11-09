extends Area2D

signal hit
signal big_hit

func get_hit():
	emit_signal("hit")

func get_big_hit():
	emit_signal("big_hit")
