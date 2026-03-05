extends Node2D


var game : MainGame

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	await get_tree().process_frame
	if (Global.game == null):
		return
	
	game = Global.game
	game.guiChanged.connect(SetVideoPlayer)


func SetVideoPlayer() -> void:	
	if(game.currentWorldScene == null):
		if (animationPlayer.is_playing()):
			return
		set_deferred("visible", true)
		animationPlayer.play("MenuIdleCurves")
	else:
		animationPlayer.stop()
		set_deferred("visible", false)
		
