extends Area2D

signal hit


func get_hit():
	emit_signal("hit")
