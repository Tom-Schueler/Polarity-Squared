extends CheckBox


func ScreenshakeToggled(toggled_on: bool) -> void:
	$"../../../..".screenshakeEnabled = toggled_on


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.screenshake


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.screenshake = button_pressed
