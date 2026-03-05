extends HSlider


@onready var sfxIndex : int = AudioServer.get_bus_index("SFX")
@export var valueGUI : Label

func SFXVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(sfxIndex, linear_to_db(value))
	valueGUI.text = str(value * 100)


func OnLoadSettings(settings : SettingMetaData) -> void:
	value = settings.sfxVolume

func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.sfxVolume = value
