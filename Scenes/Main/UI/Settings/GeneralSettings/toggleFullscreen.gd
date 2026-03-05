extends CheckBox


func FullScreenToggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) if toggled_on else DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.fullscreen


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.fullscreen = button_pressed
