extends AudioStreamPlayer


func _StartPlaying() -> void:
	if (Global.game.currentGuiSceneName != "MainMenu"):
		return
	
	Global.game.guiChanged.disconnect(_StartPlaying)
	play()


func _ready() -> void:
	await get_tree().process_frame
	Global.game.guiChanged.connect(_StartPlaying)
