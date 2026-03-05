extends CheckBox


@onready var musicIndex : int = AudioServer.get_bus_index("Music")


func MuteMusic(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(musicIndex, not toggled_on)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.musicMute


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.musicMute = button_pressed
