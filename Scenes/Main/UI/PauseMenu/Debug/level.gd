extends Button

var level : String


func SelfPressed() -> void:
	Global.game.currentCheckpointIdentifier = 0
	Global.game.currentTime = 0
	Global.game.timeAtCurrentCheckpoint = 0
	Global.game.ChangeWorldScene(level.to_int())
