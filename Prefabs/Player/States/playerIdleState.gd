class_name Idle extends State


var player : Player
var animationPlayer : AnimationPlayer

var timePassed : float


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func Enter(lastState : State) -> void:
	timePassed = 0
	
	animationPlayer.queue("Idle")


func PhysicsUpdate(delta : float) -> void:
	player.move_and_slide()
	
	timePassed += delta
	
	if (animationPlayer.current_animation == "Idle" && player.timeUntilDance <= timePassed):
		animationPlayer.play("Dance1")
		for i : int in range(0, 4):
			animationPlayer.queue("Dance1")
		
		for i : int in range(0, 4):
			animationPlayer.queue("Dance2")
			
		animationPlayer.queue("Dance3")
		animationPlayer.queue("Dance4")

	if (not player):
		print("no player asinged")
		return
	
	if (player.gravityInput != player.gravitationVector):
		stateTransition.emit(self, "ChangeGravity")
		return

	if (not player.is_on_floor()):
		stateTransition.emit(self, "Falling")
		return

	if(player.movementInput * player.gravitationVector.orthogonal().abs()):
		stateTransition.emit(self, "Moving")
		return

	if (player.jumpInput):
		print("Entered from Idle state")
		stateTransition.emit(self, "Jumping")


func Exit() -> void:
	animationPlayer.stop()
