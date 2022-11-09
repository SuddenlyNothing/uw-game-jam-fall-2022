extends Area2D


export(float) var speed := 350.0
export(Vector2) var dir := Vector2()

var velocity := Vector2()


func _ready() -> void:
	rotation = dir.angle()
	velocity = dir * speed


func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_Hitbox_area_entered(area: Area2D):
	if not area.is_in_group("hittable"):
		return
	area.get_hit()
