extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("attack")
	add_state("death")
	call_deferred("set_state", "idle")


# Contains state logic.
func _state_logic(delta: float) -> void:
	match state:
		states.idle:
			parent.slide(delta)
		states.walk:
			parent.move(delta)
		states.attack:
			parent.move_attack(delta)
		states.death:
			pass


# Return value will be used to change state.
func _get_transition(delta: float):
	match state:
		states.idle:
			if parent.hud.has_health(0):
				return states.death
			if Input.is_action_just_pressed("melee"):
				return states.attack
			if parent.input:
				return states.walk
		states.walk:
			if parent.hud.has_health(0):
				return states.death
			if Input.is_action_just_pressed("melee"):
				return states.attack
			if not parent.input:
				return states.idle
		states.attack:
			if parent.hud.has_health(0):
				return states.death
		states.death:
			return states.idle
	return null


# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state: String, old_state) -> void:
	match new_state:
		states.idle:
			parent.play_anim("idle")
		states.walk:
			parent.play_anim("walk")
		states.attack:
			parent.play_anim("attack")
		states.death:
			parent.play_anim("death")


# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state, new_state: String) -> void:
	match old_state:
		states.idle:
			pass
		states.walk:
			pass
		states.attack:
			parent.hitbox_collision.call_deferred("set_disabled", true)
		states.death:
			get_tree().reload_current_scene()
