class_name Moving extends State


@export var audioStreamPlayer : AudioStreamPlayer


var player : Player
var animationPlayer : AnimationPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func Enter(lastState : State):
	if (lastState.name == "Falling"):
		animationPlayer.play("Landing+running")
	animationPlayer.queue("Running")
	
	audioStreamPlayer.play()


func PhysicsUpdate(delta : float) -> void:
	player.MoveOnCurrentFloorAxis(delta)
	var wasOnFloor = player.is_on_floor()
	var wasOnWall = player.is_on_wall()
	player.move_and_slide()
	
	
	if (player.is_on_wall()):
		pass
	
	
	if (wasOnFloor && not player.is_on_floor()):
		player.coyoteTimer.start(player.coyoteTime)
		print("coyote time started")
	
	if (not wasOnWall && player.is_on_wall() || wasOnWall && player.is_on_wall()):
		stateTransition.emit(self, "OnWall")
		return
	
	if (player.gravityInput != player.gravitationVector):
		stateTransition.emit(self, "ChangeGravity")
		return
	
	if ((player.velocity * player.gravitationVector.orthogonal()).length() < 0.001 && !player.movementInput):
		stateTransition.emit(self, "Idle")
		return

	if (player.jumpInput):
		print("Entered from Moving state")
		stateTransition.emit(self, "Jumping")
		return

	if (not player.is_on_floor()):
		stateTransition.emit(self, "Falling")


func Exit() -> void:
	animationPlayer.stop()
	audioStreamPlayer.stop()
