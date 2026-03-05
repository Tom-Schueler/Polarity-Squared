class_name ChangeGravity extends State


@export var audioStreamPlayer : AudioStreamPlayer


var player : Player
var animationPlayer : AnimationPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer


func Enter(lastState : State) -> void:
	audioStreamPlayer.play()
	match lastState.name:
		"Moving":
			animationPlayer.play("Gravity Switch")
		
		"Idle":
			animationPlayer.play("Gravity Switch")
		
		"Falling":
			animationPlayer.play("Gravity Switch_Fall")
	
	match player.gravityInput:
		Vector2.UP:
			player.surfaceAlignment = player.SurfaceAlignment.UP
		
		Vector2.LEFT:
			player.surfaceAlignment = player.SurfaceAlignment.LEFT
		
		Vector2.DOWN:
			player.surfaceAlignment = player.SurfaceAlignment.DOWN
		
		Vector2.RIGHT:
			player.surfaceAlignment = player.SurfaceAlignment.RIGHT


func PhysicsUpdate(delta) -> void:
	player.move_and_slide()

	if (not player.is_on_floor()):
		stateTransition.emit(self, "Falling")
	else:
		stateTransition.emit(self, "Idle")
