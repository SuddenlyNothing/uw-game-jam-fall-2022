extends StateMachine

onready var wander_controller = $"../WanderController"
func _ready() -> void:
	add_state("patrol")
	add_state("engage")
	add_state("idle")
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
			pass
		states.patrol:
#			print(wander_controller.get_time_left())
			if parent.detect:
				print("engage!")
				return states.engage
			if wander_controller.get_time_left() == 0:
				wander_controller.start_wander_timer(rand_range(1, 3))
				return states.idle

func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state: String, old_state) -> void:
	pass


# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state: String) -> void:
	pass

func _seek_player():
	if parent.detect:
		print("engage!")
		return states.engage
