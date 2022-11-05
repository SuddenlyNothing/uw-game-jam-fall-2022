extends Area2D

export(float) var rot_speed := 1.0
export(float) var horizontal_move := 30.0
export(float) var vertical_move := 60.0
export(float) var dur := 0.5

onready var collision := $CollisionShape2D


func _ready() -> void:
	Variables.rng.randomize()
	var t := create_tween().set_parallel()
	var new_x := position.x + Variables.rng.randf_range(-horizontal_move,
			horizontal_move)
	t.tween_property(self, "position:x", new_x, dur)
	var move_amount := Variables.rng.randf_range(0, vertical_move)
	var y_move := position.y - move_amount
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "position:y", y_move, dur / 2).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "position:y",
			y_move + Variables.rng.randf_range(move_amount / 2,
			vertical_move) / 2, dur / 2)\
			.from(y_move).set_delay(dur / 2).set_ease(Tween.EASE_IN)
	t.chain().tween_callback(collision, "set_disabled", [false])


func _physics_process(delta: float) -> void:
	rotation += 6.28319 * rot_speed * delta
