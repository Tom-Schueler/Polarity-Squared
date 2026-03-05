extends CheckBox


func DbugModeToggled(toggled_on: bool) -> void:
	$"../../../../..".debugModeEnabled = toggled_on


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.debugMode


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.debugMode = button_pressed
