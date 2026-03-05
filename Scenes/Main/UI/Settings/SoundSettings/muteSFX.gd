extends CheckBox


@onready var sfxIndex : int = AudioServer.get_bus_index("SFX")


func MuteSFX(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(sfxIndex, not toggled_on)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.sfxMute


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.sfxMute = button_pressed
