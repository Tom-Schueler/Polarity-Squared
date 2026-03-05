extends Control


var game : MainGame = Global.game

func _ready() -> void:
	game.music.pitch_scale = .95

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause") && game.currentGuiSceneName == "GameUI"):
		get_tree().paused = true
		game.ChangeGuiScene("PauseMenu", false)
	
	if event.is_action_pressed("Reset"):
		game.ChangeWorldScene(game.currentWorldSceneName)
		PhysicsServer2D.area_set_param(
		get_viewport().find_world_2d().space,
		PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
