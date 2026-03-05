extends CheckBox


func TimerToggled(toggled_on: bool) -> void:
	$"../../../../..".timerEnabled = toggled_on


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.timerEnabled


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.timerEnabled = button_pressed
