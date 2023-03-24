extends Node
class_name StateMachine

var state = null setget set_state
var prevState = null

var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(newState, oldState):
	pass

func _exit_state(old_state, newState):
	pass

func set_state(newState):
	prevState = state
	state = newState
	
	if prevState != null:
		_exit_state(prevState, state)
	if state != null:
		_enter_state(state, prevState)

func add_state(stateName):
	states[stateName] = states.size()
	
	
