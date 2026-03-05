extends Control


@export var audioStreamPlayer : AudioStreamPlayer
@export var saveGameButton : PackedScene
 

var game : MainGame = Global.game


func NewGame() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	if (game.currentWorldScene != null):
		game.currentWorldScene.call_deferred("queue_free")
		game.currentWorldScene = null
	get_tree().paused = false
	game.ChangeGuiScene("NewGame")


func BackPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	if (game.lastGuiSceneName == ""):
		game.ChangeGuiScene("MainMenu")
		return
	
	game.ChangeGuiScene(game.lastGuiSceneName)


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		BackPressed()


func _ready() -> void:
	var dir : DirAccess = DirAccess.open("user://")
	
	if (not dir.dir_exists(game.SAVE_FOLDER_PATH)):
		return
	
	dir.change_dir(game.SAVE_FOLDER_PATH)
	
	var files : PackedStringArray = dir.get_files()
	var fileInfos : Array[Dictionary]
	
	for file : String in files:
		var filePath = dir.get_current_dir() + "/" + file
		var modificationTime : int = FileAccess.get_modified_time(filePath)
		fileInfos.append({"name": file, "time": modificationTime})
	
	fileInfos.sort_custom(func(a,b): return a["time"] > b["time"])
	
	for fileInfo : Dictionary in fileInfos:
		var instance : SavedGameButton = saveGameButton.instantiate()
		instance.file = fileInfo["name"]
		get_node("CenterContainer/ScrollContainer/VBoxContainer").add_child(instance)
