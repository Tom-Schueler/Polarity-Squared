class_name Falling extends State


@export var audioStreamPlayer : AudioStreamPlayer


var player : Player
var animationPlayer : AnimationPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func Enter(lastState : State) -> void:
	animationPlayer.queue("Falling")


func PhysicsUpdate(delta : float) -> void:
	player.ApplyGravity(delta)
	player.MoveOnCurrentFloorAxis(delta)
	player.move_and_slide()
	
	if (player.gravityInput != player.gravitationVector && player.currentStamina > 0):
		stateTransition.emit(self, "ChangeGravity")
		return
	
	if (player.jumpInput && not player.coyoteTimer.is_stopped()):
		stateTransition.emit(self, "Jumping")
		return

	if (player.is_on_floor()):
		audioStreamPlayer.play()
		if (player.movementInput != Vector2.ZERO || not (player.velocity * player.gravitationVector.orthogonal()).length() < 0.001):
			stateTransition.emit(self, "Moving")
			return
		
		stateTransition.emit(self, "Idle")


func Exit() -> void:
	player.gravity = player.savedGravity
	animationPlayer.play("Landing")
