extends VideoStreamPlayer

var game : MainGame = Global.game

func _ready() -> void:
	await get_tree().process_frame
	if (Global.game.debugModeEnabled == true):
		Global.game.ChangeGuiScene("MainMenu")


func Finished() -> void:
	Global.game.ChangeGuiScene("MainMenu")
	game.music.play()
	game.music.pitch_scale = 0.75
