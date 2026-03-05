extends HSlider


@export var valueGUI : Label


func RespawnTimer(value: float) -> void:
	$"../../../../..".respawnTimer = value
	valueGUI.text = "%.2f" % value + " sec."


func OnLoadSettings(settings : SettingMetaData) -> void:
	value = settings.respawnTimer


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.respawnTimer = value
