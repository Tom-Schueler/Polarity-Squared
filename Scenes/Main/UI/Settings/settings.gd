class_name Settings extends Control


@export var defaultSettings : SettingMetaData
@export var audioStreamPlayer : AudioStreamPlayer


var game : MainGame = Global.game
var newSettings : SettingMetaData

var screenshakeEnabled : bool
var timerEnabled : bool
var respawnTimer : float
var debugModeEnabled : bool


func BackPressed() -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
	SaveSettings()
	if (game.lastGuiSceneName == ""):
		game.ChangeGuiScene("MainMenu")
		return
	
	game.ChangeGuiScene(game.lastGuiSceneName)


func LoadSettings(settings : SettingMetaData = defaultSettings) -> void:
	get_tree().call_group("setting", "OnLoadSettings", settings)


func SaveSettings() -> void:
	var dir : DirAccess = DirAccess.open("user://")
	var path : String = game.SETTINGS_FILE_PATH.substr(0, game.SETTINGS_FILE_PATH.rfind("/"))
	var newSettings : SettingMetaData = SettingMetaData.new()
	
	get_tree().call_group("setting", "OnSaveSettings", newSettings)
	
	if (not dir.dir_exists(path)):
		var err = dir.make_dir_recursive(path)
		if err != OK:
			print("Failed to create folder")
			return
	
	ResourceSaver.save(newSettings, game.SETTINGS_FILE_PATH)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		BackPressed()

func _ready() -> void:
	if (not ResourceLoader.exists(game.SETTINGS_FILE_PATH)):
		LoadSettings()
		return
		
	var settings : SettingMetaData = load(game.SETTINGS_FILE_PATH)
	LoadSettings(settings)
