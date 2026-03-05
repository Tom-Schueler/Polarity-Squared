extends CheckBox


@onready var uiIndex : int = AudioServer.get_bus_index("UI")


func MuteUI(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(uiIndex, not toggled_on)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.uiMute


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.uiMute = button_pressed
