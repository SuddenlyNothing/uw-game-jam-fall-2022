extends CanvasLayer

export(int) var max_soul_power := 10

var soul_power: int = 0 setget set_soul_power
var t: SceneTreeTween

onready var soul_bar := $Control/M/SoulBar


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
