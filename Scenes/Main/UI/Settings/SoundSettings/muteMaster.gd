extends CheckBox


@onready var masterIndex : int = AudioServer.get_bus_index("Master")


func MuteMaster(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(masterIndex, not toggled_on)


func OnLoadSettings(settings : SettingMetaData) -> void:
	button_pressed = settings.masterMute


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.masterMute = button_pressed
