extends Control


@export var audioStreamPlayer : AudioStreamPlayer


var game : MainGame = Global.game


func SaveCurrent() -> void:
	var dir : DirAccess = DirAccess.open("user://")
	var savedGame : SavedGame = SavedGame.new()
	
	savedGame.level = game.currentWorldSceneName
	savedGame.checkpointIdentifier = game.currentCheckpointIdentifier
	savedGame.checkpointPositon = game.currentCheckpointPosition
	savedGame.timeAtCurrentCheckpoint = game.timeAtCurrentCheckpoint
	savedGame.times = game.times
	savedGame.deaths = game.currentDeathCount
	
	if (not dir.dir_exists(game.SAVE_FOLDER_PATH)):
		print("could not be saved")
		return
	
	ResourceSaver.save(savedGame, game.currentSave)


func SavePressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	SaveCurrent()


func LoadPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	SaveCurrent()
	
	game.ChangeGuiScene("Saves")


func SettingsPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	game.ChangeGuiScene("Settings")


func MainMenuPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	SaveCurrent()
	get_tree().paused = false
	if(game.currentWorldScene != null):
		game.currentWorldScene.queue_free()
	game.currentWorldScene = null
	game.ChangeGuiScene("MainMenu")


func QuitPressed() -> void:
	audioStreamPlayer.play()
	SaveCurrent()
	get_tree().call_deferred("quit")
	get_tree().paused = false
	#game.ChangeGuiScene("GameUI")


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause") && game.currentGuiSceneName == "PauseMenu"):
		get_tree().paused = false
		game.ChangeGuiScene("GameUI")
	
