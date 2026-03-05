extends CheckBox


func BorderlessToggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.borderless


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.borderless = button_pressed
