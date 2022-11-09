extends StateMachine

onready var wander_controller = $"../WanderController"
func _ready() -> void:
	add_state("patrol")
	add_state("engage")
	add_state("idle")
	add_state("attack")
	call_deferred("set_state", "idle")


# Contains state logic.
func _state_logic(delta: float) -> void:
	match state:
		states.idle:
			pass
		states.engage:
			parent.move(delta)
		states.patrol:
			parent.direction = parent.global_position.direction_to(wander_controller.target_position)
			if parent.global_position.distance_to(wander_controller.target_position) >= parent._wander_target_range:
				parent.accelerate(delta)
				parent.move_and_slide(parent._velocity)
		states.attack:
			if parent._attack_interval.get_time_left() == 0:
				parent._attack_interval.start()
			parent.move_attack(delta)
#			if parent._shoot_interval.get_time_left() == 0:
#				parent._shoot_interval.start()
#			parent._shoot_timer.start()	



# Return value will be used to change state.
func _get_transition(delta: float):
	match state:
		states.idle:
			if parent.detect:
				print("engage!")
				return states.engage
			if wander_controller.get_time_left() == 0:
				wander_controller.start_wander_timer(rand_range(1, 3))
				return states.patrol
		states.engage:
			if parent._in_range:
				return states.attack
		states.patrol:
#			print(wander_controller.get_time_left())
			if parent.detect:
				return states.engage
			if wander_controller.get_time_left() == 0:
				wander_controller.start_wander_timer(rand_range(1, 3))
				return states.idle
		states.attack:
			
			if !(parent._in_range):
				return states.engage

func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.idle:
			parent.play_anim("idle")
		states.engage:
			parent.play_anim("engage")
		states.patrol:
			parent.play_anim("patrol")
		states.attack:
			parent.play_anim("attack")


# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state: String) -> void:
	pass

func _seek_player():
	if parent.detect:
		print("engage!")
		return states.engage
