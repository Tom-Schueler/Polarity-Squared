extends Control


@export var audioStreamPlayer : AudioStreamPlayer


var game : MainGame = Global.game


func BackPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	game.ChangeGuiScene("MainMenu")


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		BackPressed()
