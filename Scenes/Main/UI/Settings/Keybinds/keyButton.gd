extends Button


@export var actionKey : String


@onready var overlay : Panel = %Overlay


signal input


var inputKeycode : int


func _input(event: InputEvent) -> void: 
	if (event.is_echo()):
		return
	
	if(event is InputEventKey):
		input.emit(event)


func SelfPressed() -> void:
	overlay.visible = true
	var oldText = text
	text = "Set new Input..."
	
	var event : InputEvent = await self.input
	
	if (event.keycode == KEY_ENTER):
		print("donde work")
		return
		
	if (event.keycode == KEY_ESCAPE || event.keycode == KEY_R):
		text = oldText
		overlay.visible = false
		return
	
	if (event.keycode == KEY_CTRL || event.keycode == KEY_ALT):
		pass
		#TODO maybe shift + input or ctrl + input... mal sehen
	
	text = event.as_text()
	inputKeycode = event.keycode
	InputMap.action_erase_events(actionKey)
	InputMap.action_add_event(actionKey, event)
	
	overlay.visible = false


func OnLoadSettings(settings : SettingMetaData) -> void:
	if (not settings.inputSettingsMap.has(actionKey) || actionKey == ""):
		text = "error"
		return
	
	var key : int = settings.inputSettingsMap[actionKey]
	var event : InputEventKey = InputEventKey.new()
	
	event.keycode = key
	inputKeycode = key
	text = event.as_text_keycode()
	InputMap.action_erase_events(actionKey)
	InputMap.action_add_event(actionKey, event)


func OnSaveSettings(newSettings : SettingMetaData) -> void:
	newSettings.inputSettingsMap[actionKey] = inputKeycode
