extends HSlider


@onready var uiIndex : int = AudioServer.get_bus_index("UI")
@export var valueGUI : Label


func UIVolume(value: float) -> void:
	AudioServer.set_bus_volume_db(uiIndex, linear_to_db(value))
	valueGUI.text = str(value * 100)


func OnLoadSettings(settings : SettingMetaData) -> void:
	value = settings.uiVolume


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.uiVolume = value
