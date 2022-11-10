extends Node2D
export(String, FILE, "*.tscn") var next_scene

var continued := false

func _ready() -> void:
	randomize()
	MusicPlayer.play("level")

func _input(event: InputEvent) -> void:
	if continued:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	if event.is_action_pressed("continue") and len(enemies) == 0:
		continued = true
		SceneHandler.goto_scene(next_scene)

func _on_Player_player_dead(a):
	SceneHandler.restart_scene()
