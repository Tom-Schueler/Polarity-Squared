extends Sprite2D

var game : MainGame = Global.game
var levelFinished : bool

func _ready() -> void:
	game.worldChanged.connect(UpdateDeathCount)

func UpdateDeathCount() -> void:
	
	pass

func _process(delta: float) -> void:
	if (levelFinished == true):
		return
	
	if (Global.game.timerEnabled != visible):
		set_deferred("visible", Global.game.timerEnabled)
	$DeathCounter.text = str(game.currentDeathCount)
