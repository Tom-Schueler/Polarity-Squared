class_name SavedGameButton extends TextureButton


@export var audioStreamPlayer : AudioStreamPlayer


var file : String
var game : MainGame = Global.game


func _ready() -> void:
	get_node("Label").text = file.get_slice(".", 0)


func SelfPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	game.music.pitch_scale = .95
	
	var filePath : String = game.SAVE_FOLDER_PATH + file
	var savedGame : SavedGame = load(filePath)
	
	game.currentCheckpointPosition = savedGame.checkpointPositon
	game.currentCheckpointIdentifier = savedGame.checkpointIdentifier
	game.currentTime = savedGame.timeAtCurrentCheckpoint
	game.times = savedGame.times
	game.currentDeathCount = savedGame.deaths
	game.ChangeWorldScene(savedGame.level)
	
	
	
	
	game.currentSave = filePath
	game.ChangeGuiScene("GameUI")
	get_tree().paused = false


func DeletePressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	var dir : DirAccess = DirAccess.open(game.SAVE_FOLDER_PATH)
	
	if (dir.file_exists(file)):
		dir.remove(file)
	queue_free()
