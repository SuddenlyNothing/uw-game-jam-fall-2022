extends KinematicBody2D

const EnemySoulBullet := preload("res://scenes/characters/enemies/EnemySoulBullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var acceleration := 700.0
export(float) var turn_acceleration := 1500.0
export(float) var max_speed := 50.0
export(float) var friction := 1000.0
export(int) var health:= 10

var _velocity := Vector2.ZERO
var direction := Vector2.ZERO
export var _path_to_player := NodePath()
export var _wander_target_range = 4
onready var _agent : NavigationAgent2D = $NavigationAgent2D 
onready var _player : Node = get_node(_path_to_player)
onready var detect := false
onready var _timer: Timer = $PathTimer
onready var _shoot_timer := $ShootTimer
onready var _shoot_interval := $ShootInterval
onready var anim_sprite := $AnimatedSprite
onready var _state_machine :=$SmalliestState
onready var _in_range := false
const CollectableSoul := preload("res://scenes/characters/CollectableSoul.tscn")

export(int) var num_souls := 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_pathfinding()
	_timer.connect("timeout", self, "_update_pathfinding")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	direction = global_position.direction_to(_agent.get_next_location())
#	print(direction)

func accelerate(delta: float) -> void:
	var desired_vel:= direction * max_speed
	var acceleration_amount = delta
	if desired_vel.normalized().dot(_velocity.normalized()) < 0:
		acceleration_amount *= turn_acceleration
	else:
		acceleration_amount *= acceleration
	if _velocity.distance_to(desired_vel) < acceleration_amount:
		_velocity = desired_vel
	else:
		_velocity += _velocity.direction_to(desired_vel) * acceleration_amount

func move(delta: float) -> void:
	if _agent.is_navigation_finished():
		return
	accelerate(delta)
	move_and_slide(_velocity)
	
func slide(delta: float) -> void:
	apply_friction(delta)
	move_and_slide(_velocity)

func apply_friction(delta: float) -> void:
	var friction_amount := friction * delta
	if friction_amount > _velocity.length():
		_velocity = Vector2()
	else:
		_velocity -= _velocity.normalized() * friction_amount

func _on_EnemyHurtbox_hit() -> void:
	health -= 5
	print(health)
	if health <= 0:
		_dies()
	for i in num_souls:
		var cs := CollectableSoul.instance()
		cs.position = position
		get_parent().call_deferred("add_child", cs)


func _on_DetectionBox_body_entered(body: Node):
	if body.is_in_group("player"):
		detect = true
	pass # Replace with function body.

func _update_pathfinding() -> void:
	_agent.set_target_location(_player.global_position)

func _dies() -> void:
	_state_machine.call_deferred("set_state", "death")


func _on_RangeArea2D_body_entered(body: Node):
	if body.is_in_group("player"):
		_in_range = true
		

func shoot() -> void:
	var esb := EnemySoulBullet.instance()
	esb.position = position
	# get direction from current position to player
	esb.dir = global_position.direction_to(_player.global_position)
	get_parent().add_child(esb)

func play_anim(anim: String) -> void:
	anim_sprite.play(anim)

func _on_ShootTimer_timeout():
	_shoot_interval.stop()


func _on_ShootInterval_timeout():
	shoot()


func _on_RangeArea2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_in_range = false

func _on_AnimatedSprite_animation_finished():
	if anim_sprite.animation == "shoot":
		_state_machine.call_deferred("set_state", "engage")
	if anim_sprite.animation == "death":
		queue_free()
