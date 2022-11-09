extends KinematicBody2D
const SoulBullet := preload("res://scenes/characters/player/SoulBullet.tscn")

export(float) var acceleration := 700.0
export(float) var turn_acceleration := 1500.0
export(float) var friction := 1000.0
export(float) var max_speed := 100.0
export(int) var health := 100

var velocity := Vector2()
var input := Vector2()

onready var pivot := $Pivot
onready var anim_sprite := $Pivot/AnimatedSprite
onready var hud := $HUD
onready var shoot_timer := $ShootTimer
onready var shoot_interval := $ShootInterval
onready var hitbox_collision := $Pivot/Hitbox/CollisionShape2D
onready var player_states := $PlayerStates


func _process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("shoot") and shoot_timer.is_stopped() and \
			hud.has_soul_power(1):
		hud.remove_soul_power()
		shoot()
		shoot_timer.start()
		shoot_interval.start()
	set_facing(input)


func play_anim(anim: String) -> void:
	anim_sprite.play(anim)


func slide(delta: float) -> void:
	apply_friction(delta)
	move_and_slide(velocity)


func move(delta: float) -> void:
	accelerate(delta)
	move_and_slide(velocity)


func move_attack(delta: float) -> void:
	accelerate(delta)
	apply_friction(delta)
	move_and_slide(velocity)


func accelerate(delta: float) -> void:
	if not input:
		return
	var desired_vel := input * max_speed
	var acceleration_amount := delta
	if desired_vel.normalized().dot(velocity.normalized()) < 0:
		acceleration_amount *= turn_acceleration
	else:
		acceleration_amount *= acceleration
	if velocity.distance_to(desired_vel) < acceleration_amount:
		velocity = desired_vel
	else:
		velocity += velocity.direction_to(desired_vel) * acceleration_amount


func apply_friction(delta: float) -> void:
	if input:
		return
	var friction_amount := friction * delta
	if friction_amount > velocity.length():
		velocity = Vector2()
	else:
		velocity -= velocity.normalized() * friction_amount


func shoot() -> void:
	var sb := SoulBullet.instance()
	sb.position = position
	sb.dir = get_local_mouse_position().normalized()
	get_parent().add_child(sb)


func set_facing(dir: Vector2) -> void:
	if (pivot.scale.x < 0 and dir.x > 0) or \
			(pivot.scale.x > 0 and dir.x < 0):
		pivot.scale.x *= -1


func _on_CollectSouls_area_entered(area: Area2D) -> void:
	if not area.is_in_group("soul"):
		return
	area.queue_free()
	hud.add_soul_power(1)


func _on_ShootTimer_timeout() -> void:
	shoot_interval.stop()


func _on_ShootInterval_timeout() -> void:
	shoot()


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hittable"):
		return
	area.get_hit()


func _on_AnimatedSprite_frame_changed() -> void:
	match anim_sprite.animation:
		"attack":
			match anim_sprite.frame:
				2:
					hitbox_collision.call_deferred("set_disabled", false)


func _on_AnimatedSprite_animation_finished() -> void:
	player_states.call_deferred("set_state", "idle")
	

func _on_PlayerHurtBox_hit():
	hud.remove_player_health(5)


func _on_PlayerHurtBox_big_hit():
	hud.remove_player_health(30)
