extends StateMachine
var is_death = false

onready var wander_controller = $"../WanderController"
func _ready() -> void:
	add_state("patrol")
	add_state("engage")
	add_state("death")
	add_state("shoot")
	call_deferred("set_state", "patrol")


# Contains state logic.
func _state_logic(delta: float) -> void:
	match state:
		states.engage:
			parent.anim_sprite.flip_h = parent._velocity.x < 0
			parent.move(delta)
		states.patrol:
			parent.direction = parent.global_position.direction_to(wander_controller.target_position)
			if parent.global_position.distance_to(wander_controller.target_position) >= parent._wander_target_range:
				parent.accelerate(delta)
				parent.move_and_slide(parent._velocity)
			parent.anim_sprite.flip_h = parent._velocity.x < 0
		states.shoot:
			parent.anim_sprite.flip_h = parent.global_position.direction_to(parent._agent.get_next_location()).x < 0
			if parent._shoot_interval.get_time_left() == 0:
				parent._shoot_interval.start()
#			parent._shoot_timer.start()	



# Return value will be used to change state.
func _get_transition(delta: float):
	match state:
		states.engage:
			if parent._in_range:
				return states.shoot
		states.patrol:
#			print(wander_controller.get_time_left())
			if parent.detect:
				return states.engage
			if wander_controller.get_time_left() == 0:
				wander_controller.start_wander_timer(rand_range(1, 3))
		states.shoot:
			if !(parent._in_range):
				return states.engage
		states.death:
			pass

func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.engage:
			parent.play_anim("running")
		states.patrol:
			parent.play_anim("running")
		states.shoot:
			parent.play_anim("attack")
		states.death:
			parent.play_anim("death")


# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state: String) -> void:
	pass

func set_state(new_state: String) -> void:
	if is_death:
		return
	if new_state == states.death:
		is_death = true
	.set_state(new_state) 
