extends HSlider


@onready var musicIndex : int = AudioServer.get_bus_index("Music")
@export var valueGUI : Label


func MusicVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(musicIndex, linear_to_db(value))
	valueGUI.text = str(value * 100)


func OnLoadSettings(settings : SettingMetaData) -> void:
	value = settings.musicVolume


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.musicVolume = value
