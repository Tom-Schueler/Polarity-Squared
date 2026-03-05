class_name OnWall extends State


var player : Player
var animationPlayer : AnimationPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func Enter(lastState : State) -> void:
	animationPlayer.queue("Idle_Wall")


func PhysicsUpdate(delta : float) -> void:
	player.MoveOnCurrentFloorAxis(delta)
	var wasOnWall = player.is_on_wall()
	player.move_and_slide()
	
	if (wasOnWall && not player.is_on_wall()):
		stateTransition.emit(self, "Moving")
		return
		
	if (player.gravityInput != player.gravitationVector):
		stateTransition.emit(self, "ChangeGravity")
		return
	
	if (player.jumpInput):
		print("Entered from Moving state")
		stateTransition.emit(self, "Jumping")
		return
	
	if (not player.is_on_floor()):
		stateTransition.emit(self, "Falling")


func Exit() -> void:
	animationPlayer.stop()
