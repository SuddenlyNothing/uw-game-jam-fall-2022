extends CanvasLayer

export(int) var max_soul_power := 10
export(int) var max_player_health:= 100

var soul_power: int = 0 setget set_soul_power
var player_health: int = 100 setget set_player_health
var t: SceneTreeTween

onready var soul_bar := $Control/M/SoulBar
onready var player_health_ui = $Control/M/HealthBar


func add_soul_power(amt: int = 1) -> void:
	set_soul_power(soul_power + amt)
	


func remove_soul_power(amt: int = 1) -> void:
	set_soul_power(soul_power - amt)


func set_soul_power(val: int) -> void:
	soul_power = min(val, max_soul_power)
	if t:
		t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(soul_bar, "value", soul_power / float(max_soul_power), 0.15)

func has_soul_power(amt: int) -> bool:
	return soul_power >= amt

func set_player_health(val: int) -> void:
	player_health = min(val, max_player_health)
	if t:
		t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(player_health_ui, "value", player_health / float(max_player_health), 0.15)

func add_player_health(amt: int = 1) -> void:
	set_player_health(player_health + amt)
	
func remove_player_health(amt: int = 1) -> void:
	set_player_health(player_health - amt)

func has_health(amt: int) -> bool:
	return player_health <= amt
