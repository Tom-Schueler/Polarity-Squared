class_name Finite_State_Machine extends Node


@export var initialState : State
@export var animations : Node2D


var states : Dictionary = {}
var currentState : State


func ChangeState(sourceState : State, newStateName : String) -> void:
	if (sourceState != currentState):
		print("Invalid ChangeState trying from: " + sourceState.name + " but currently in: " + currentState.name)
		return
	
	var newState = states.get(newStateName.to_lower())
	if (not newState):
		print("New state is empty")
		return
	
	if (currentState):
		currentState.Exit()
		
	newState.Enter(currentState)
	
	currentState = newState


func _Kill(cause : String, stateName : String) -> void:
	var deadState : Dead = states.get(stateName.to_lower())
	deadState.cause = cause
	ForceChangeState(stateName)

# use carefully...
func ForceChangeState(newStateName : String):
	var newState : State = states.get(newStateName.to_lower())
	
	if (not newState):
		print(str(newState) + " does not exist in the dictionary of states")
		return
	
	if (currentState == newState):
		print("State is same, aborting")
		return
	
	if (currentState):
		var exitCallable : Callable = Callable(currentState, "Exit")
		exitCallable.call_deferred()
	
	newState.Enter(currentState)

	currentState = newState


func _ready() -> void:
	var animationPlayer : AnimationPlayer = animations.find_child("AnimationPlayer")
	var object = get_parent()
	
	if (object.has_signal("kill")):
		object.kill.connect(_Kill)
	
	for child in get_children():
		if (child is State):
			states[child.name.to_lower()] = child
			child.stateTransition.connect(ChangeState)
			child.ReferenceCharacterBody(object, animationPlayer)
	
	if (initialState):
		initialState.Enter(null)
		currentState = initialState
	else:
		print("Asign initial state at 'Finite State Machine' in Inspector first.")


func _process(delta : float) -> void:
	if (currentState):
		currentState.Update(delta)


func _physics_process(delta : float) -> void:
	if (currentState):
		currentState.PhysicsUpdate(delta)
