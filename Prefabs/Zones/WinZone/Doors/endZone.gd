extends Area2D


@export var fadeOutTimer : float = .4
@onready var animationPlayer = $Door/AnimationPlayer


var camera : Camera2D
var hasPlayedAnimation = false
var game : MainGame = Global.game


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		#TODO: Disable player movement when entering goal
		if animationPlayer.is_playing():
			await animationPlayer.animation_finished
		
		game.levelFinished.emit()
		camera.InitiateFadeOut(fadeOutTimer)
		game.currentCheckpointIdentifier = 0
		game.currentTime = 0
		game.timeAtCurrentCheckpoint = 0
		ChangeScene()


func ChangeScene() -> void:
	await get_tree().create_timer(fadeOutTimer + 0.1).timeout
	
	if (game.currentWorldScene != null):
		game.currentWorldScene.call_deferred("queue_free")
		game.currentWorldScene = null
	get_tree().paused = false
	game.ChangeGuiScene("Credits")


func _on_open_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") && !hasPlayedAnimation):
		animationPlayer.play("Open", -1, 3)
		hasPlayedAnimation = true
		for child in body.get_children():
			if(child is Camera2D):
				camera = child
				camera.InitiateCameraShake(animationPlayer.current_animation_length / 2)
