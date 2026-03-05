extends ColorRect


var game : MainGame


func _ready() -> void:
	await get_tree().process_frame
	if (Global.game == null):
		return
	
	game = Global.game
	game.guiChanged.connect(SetBlur)


func SetBlur() -> void:
	if (not game.currentGuiSceneName == "GameUI" && not game.currentWorldScene == null):
		visible = true
	else:
		visible = false
