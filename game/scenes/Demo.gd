extends Node2D


func _ready() -> void:
	randomize()
	MusicPlayer.play("level")
