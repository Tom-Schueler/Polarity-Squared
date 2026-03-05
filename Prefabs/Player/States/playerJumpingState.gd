class_name Jumping extends State


@export var audioStreamPlayer : AudioStreamPlayer


var player : Player
var animationPlayer : AnimationPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func CalculateJumpVelocity() -> Vector2: #Could be reused
	return player.velocity * player.gravitationVector.orthogonal().abs() + -player.gravitationVector * player.jumpHeight


func Enter(lastState : State) -> void:
	audioStreamPlayer.play()
	player.isJumping = true
	
	#This calculates the Jump height and Jump direction based on the Gravity direction
	player.velocity = CalculateJumpVelocity()
	player.lastGravityVelocity = player.velocity #Saves velocity to use in variable Jump Height
	
	animationPlayer.play("Jump")

func PhysicsUpdate(delta : float) -> void:
	player.ApplyGravity(delta)
	player.MoveOnCurrentFloorAxis(delta)
	player.move_and_slide()
	
	var verticalVelocity = player.velocity.dot(-player.gravitationVector)
	var isAscending = verticalVelocity > 0

	if (Input.is_action_just_released("Jump") && isAscending):
		#Reduce vertical velocity while preserving horizontal momentum
		var newVertical = verticalVelocity * player.variableJumpHeight
		player.velocity = player.velocity * player.gravitationVector.orthogonal().abs()  #Keep horizontal
		player.velocity += -player.gravitationVector * newVertical  #Apply reduced vertical
		
	if verticalVelocity <= 400: #air hang time
		player.gravity *= player.hangTime
	
	if (player.gravityInput != player.gravitationVector):
		stateTransition.emit(self, "ChangeGravity")
		return
	
	#Transition to falling when descending
	if verticalVelocity <= 0:
		player.gravity = player.savedGravity
		stateTransition.emit(self, "Falling")

func Exit() -> void:
	player.isJumping = false
	player.gravity *= player.fallSpeedMultiplier
