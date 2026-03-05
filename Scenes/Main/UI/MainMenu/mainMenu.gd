extends Control


@export var audioStreamPlayer : AudioStreamPlayer
var game : MainGame = Global.game

func _ready() -> void:
	game.music.pitch_scale = 0.75

# TODO dupplicate code with savedGameButton (also loading first world scene
# multible scripts use duplicate code... maybe i should fix that
func QuickLoadPressed() -> void:
#audioStreamPlayer.play()
#await  audioStreamPlayer.finished
	var dir : DirAccess = DirAccess.open("user://")
	game.music.pitch_scale = .95
	
	if (not dir.dir_exists(Global.game.SAVE_FOLDER_PATH)):
		return
	
	dir.change_dir(Global.game.SAVE_FOLDER_PATH)
	
	var files : PackedStringArray = dir.get_files()
	
	if (files.is_empty()):
		return
		
	var fileInfos : Array[Dictionary]
	
	for file : String in files:
		var filePath = dir.get_current_dir() + "/" + file
		var modificationTime : int = FileAccess.get_modified_time(filePath)
		fileInfos.append({"name": file, "time": modificationTime})
	
	fileInfos.sort_custom(func(a,b): return a["time"] > b["time"])
	var savedGame : SavedGame = load(Global.game.SAVE_FOLDER_PATH + fileInfos[0]["name"])
	Global.game.currentSave = Global.game.SAVE_FOLDER_PATH + fileInfos[0]["name"]
	
	if (Global.game.currentWorldScene == null):
		Global.game.ChangeWorldScene(savedGame.level)
		
		Global.game.currentCheckpointPosition = savedGame.checkpointPositon
		Global.game.currentCheckpointIdentifier = savedGame.checkpointIdentifier
		Global.game.timeAtCurrentCheckpoint = savedGame.timeAtCurrentCheckpoint
		Global.game.times = savedGame.times
		Global.game.currentDeathCount = savedGame.deaths
	
	Global.game.ChangeGuiScene("GameUI")
	
	get_tree().paused = false


func LoadPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	Global.game.ChangeGuiScene("Saves")


func SettingsPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	Global.game.ChangeGuiScene("Settings")


func QuitPressed() -> void:
	audioStreamPlayer.play()
	get_tree().call_deferred("quit")
	game.ChangeGuiScene("MainMenu")


func CreditsPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	Global.game.ChangeGuiScene("Credits")
