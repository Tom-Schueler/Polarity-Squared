extends Control


@export var nameSetter : LineEdit
@export var warningLabel : Label
@export var warningDisapearTimer : Timer
@export var audioStreamPlayer : AudioStreamPlayer


var game : MainGame = Global.game


func warningTimerTimeout() -> void:
	warningLabel.set_deferred("visible", false)


func CreatePressed() -> void:
	audioStreamPlayer.play()
	game.music.pitch_scale = .95
	await  audioStreamPlayer.finished
	var saveGameName : String = nameSetter.text
	
	if (saveGameName == ""):
		return
	
	var dir : DirAccess = DirAccess.open("user://")
	var newFilePath : String = game.SAVE_FOLDER_PATH + saveGameName + ".tres"
	
	if (dir.file_exists(newFilePath)):
		warningLabel.set_deferred("visible", true)
		warningDisapearTimer.start()
		return
	
	if (not dir.dir_exists(game.SAVE_FOLDER_PATH)):
		var err = dir.make_dir_recursive(game.SAVE_FOLDER_PATH)
		if err != OK:
			print("Failed to create folder")
			return
	
	var savedGame : SavedGame = SavedGame.new()
	savedGame.level = 1
	ResourceSaver.save(savedGame, newFilePath)
	
	game.currentSave = newFilePath
	game.currentCheckpointIdentifier = 0
	game.currentTime = 0
	game.timeAtCurrentCheckpoint = 0
	game.times = []
	game.currentDeathCount = 0
	game.ChangeWorldScene(1)
	game.ChangeGuiScene("GameUI")


func BackPressed() ->void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	Global.game.ChangeGuiScene("MainMenu")


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		BackPressed()
	elif (event.is_action_pressed("ui_accept")):
		CreatePressed()
