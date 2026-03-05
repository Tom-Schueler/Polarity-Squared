extends OptionButton


func ScreenSizeSelected(index: int) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		2:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		3:
			DisplayServer.window_set_size(Vector2i(3840, 2160))
		4:
			DisplayServer.window_set_size(Vector2i(1440, 900))
		5:
			DisplayServer.window_set_size(Vector2i(1280, 1024))
		6:
			DisplayServer.window_set_size(Vector2i(1152, 648))


func OnLoadSettings(settings : SettingMetaData) -> void:
	selected = settings.resolution
	ScreenSizeSelected(settings.resolution)


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.resolution = get_selected_id()
