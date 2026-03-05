class_name Dead extends State

var game : MainGame = Global.game
var player : Player
var animationPlayer : AnimationPlayer

var cause : String
@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"

@export var audioStreamPlayerElectrefied : AudioStreamPlayer
@export var audioStreamPlayerImpaled : AudioStreamPlayer
@export var audioStreamPlayerDismembered : AudioStreamPlayer


func ReferenceCharacterBody(player : CharacterBody2D, animationPlayer : AnimationPlayer) -> void:
	self.player = player
	self.animationPlayer = animationPlayer

func Enter(lastState : State) -> void:
	for child in player.get_children():
		if (child is CollisionShape2D):
			child.set_deferred("disabled", true)
			
		if (child is Camera2D):
			child.InitiateCameraShake(0.35, 60)
	
	await get_tree().process_frame
	
	game.currentDeathCount += 1
	var explodePlayer : Node2D = load("res://Prefabs/Player/Animation/explodePlayer.tscn").instantiate()
	var ragdollPlayer : Node2D = load("res://Prefabs/Player/Animation/ragdollPlayer.tscn").instantiate()
	match cause:
		"Electrefied": 
			animationPlayer.play("Death_Electro")
			audioStreamPlayerElectrefied.play()
		
		"Dismembered":
			player.set_deferred("visible", false)
			explodePlayer.position = player.position
			player.add_sibling(explodePlayer)
			explodePlayer.ExplodeVelocity(player.velocity)
			audioStreamPlayerDismembered.play()
		
		"Impaled":
			player.set_deferred("visible", false)
			player.add_sibling(ragdollPlayer)
			ragdollPlayer.position = player.position
			ragdollPlayer.rotation_degrees = player.rotation_degrees
			player.surfaceAlignment = player.SurfaceAlignment.DOWN
			#ragdollPlayer.scale = player.playerSprite.scale
			ragdollPlayer.RagdollVelocity(player.velocity)
			audioStreamPlayerImpaled.play()
	
	await get_tree().create_timer(Global.game.respawnTimer).timeout
	
	Global.game.ChangeWorldScene(Global.game.currentWorldSceneName)
