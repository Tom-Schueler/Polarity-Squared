class_name SettingMetaData extends Resource


#Video
#--------------------------------------------------------------------------------------------------#
@export_category("General Settings")
@export var resolution : int
@export var fullscreen : bool
@export var borderless : bool
@export var screenshake : bool
@export var debugMode : bool
@export var timerEnabled : bool
@export var respawnTimer : float


#Keybinds
#--------------------------------------------------------------------------------------------------#
@export_category("Key Bindings")
@export var inputSettingsMap : Dictionary


#Sound
#--------------------------------------------------------------------------------------------------#
@export_category("Sound Settings")
@export_range(0, 1) var masterVolume : float
@export_range(0, 1) var musicVolume : float
@export_range(0, 1) var sfxVolume : float
@export_range(0, 1) var uiVolume : float

@export var masterMute : bool
@export var musicMute : bool
@export var sfxMute : bool
@export var uiMute : bool
