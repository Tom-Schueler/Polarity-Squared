extends HSlider


@onready var masterIndex : int = AudioServer.get_bus_index("Master")
@export var valueGUI : Label


func MasterVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(masterIndex, linear_to_db(value))
	valueGUI.text = str(value * 100)


func OnLoadSettings(settings : SettingMetaData) -> void:
	value = settings.masterVolume


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.masterVolume = value
