class_name MainGame extends Node


# never change these
const SAVE_FOLDER_PATH : String = "user://Saves/"
const SETTINGS_FILE_PATH : String = "user://Settings/settings.tres"


signal guiChanged
signal worldChanged
signal levelFinished


@export var world : Node2D
@export var gui : Control
@export var firstScene : String
@export var sceneMap : SceneMap

@onready var music = $AudioStreamPlayer

# Scene Stuff
var scenes : Dictionary
 
var currentWorldScene : Node2D
var currentWorldSceneName : float
var currentGuiScene : Control
var currentGuiSceneName : String
var lastGuiSceneName : String

var cachedScenes : Dictionary = {}

# Stuff with Saving
var currentSave : String

# SavedSettingsStuff
var timerEnabled : bool
var respawnTimer : float
var screenshakeEnabled : bool
var debugModeEnabled : bool
var godModeEnabled : bool
var infinateStaminaEnabled : bool

# Checkpoint also some saving things
var currentCheckpointIdentifier : int
var currentCheckpointPosition : Vector2
var currentTime : float
var timeAtCurrentCheckpoint : float
var times : Array[float]

# Death Counter
var currentDeathCount : int

func ChangeScene(newScene: String, delete: bool, currentSceneReference, parentNode: Node, sceneType: String) -> void:
	if not scenes.has(newScene):
		print_debug("Scene not found in dictionary: ", newScene)
		return

	var scenePath = scenes[newScene]
	if scenePath == "" or not ResourceLoader.exists(scenePath):
		print_debug("Invalid scene path: ", scenePath)
		return

	if currentSceneReference != null:
		var key: String = currentSceneReference.scene_file_path
		if delete:
			if cachedScenes.has(key):
				cachedScenes.erase(key)
			currentSceneReference.queue_free()
		else:
			if not cachedScenes.has(key):
				cachedScenes[key] = currentSceneReference
			parentNode.remove_child(currentSceneReference)

	var newSceneInstance : Node
	if cachedScenes.has(scenePath):
		newSceneInstance = cachedScenes[scenePath]
	else:
		newSceneInstance = load(scenePath).instantiate()

	parentNode.call_deferred("add_child", newSceneInstance)
	newSceneInstance.visible = true

	# Update the appropriate reference based on the scene type
	if sceneType == "gui":
		lastGuiSceneName = currentGuiSceneName
		currentGuiSceneName = newScene
		currentGuiScene = newSceneInstance
	elif sceneType == "world":
		currentWorldScene = newSceneInstance
		currentWorldSceneName = float(newScene)


func ChangeGuiScene(newScene : String, delete : bool = true) -> void:
	if (newScene == currentGuiSceneName):
		return
	
	if (currentGuiScene.name == "Settings"):
		_CoppySettings(currentGuiScene)
	
	ChangeScene(newScene, delete, currentGuiScene, gui, "gui")
	guiChanged.emit()


func ChangeWorldScene(newScene: float, delete: bool = true) -> void:
	ChangeScene(str(newScene), delete, currentWorldScene, world, "world")
	worldChanged.emit()


func _CoppySettings(settings : Settings) -> void:
	timerEnabled = settings.timerEnabled
	respawnTimer = settings.respawnTimer
	screenshakeEnabled = settings.screenshakeEnabled
	debugModeEnabled = settings.debugModeEnabled


func _ready() -> void:
	Global.game = self
	scenes = sceneMap.sceneMap
	scenes.make_read_only()
	var settings : Settings = $"%Settings"
	_CoppySettings(settings)
	remove_child(settings)
	
	if not scenes.has(firstScene):
		assert(false, "Scene not found in dictionary: [" + firstScene + "]")
		return

	var scenePath = scenes[firstScene]
	if scenePath == "" or not ResourceLoader.exists(scenePath):
		assert(false, "Invalid scene path: [" + scenePath + "]")
		return
	
	var firstSceneNode : Control = load(scenePath).instantiate()
	gui.add_child(firstSceneNode)
	currentGuiScene = firstSceneNode
	currentGuiSceneName = firstScene
