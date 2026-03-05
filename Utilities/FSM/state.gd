class_name State extends Node


signal stateTransition


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	pass


func ReferencePhysicsBody(player : PhysicsBody2D, animationPlayer : AnimationPlayer) -> void:
	pass


func Enter(lastState : State) -> void:
	pass


func Exit() -> void:
	pass


func Update(_delta : float) -> void:
	pass


func PhysicsUpdate(_delta : float) -> void:
	pass
