extends Sprite2D


var minPassed : int
var secondsPassed : int
var milliPassed : float
var game : MainGame = Global.game
var levelFinished : bool


func SetTimer() -> void:
	levelFinished = false
	
	var timePassed = game.currentTime
	minPassed = timePassed / 60
	secondsPassed = timePassed - (minPassed * 60)
	milliPassed = timePassed - (minPassed * 60 + secondsPassed)


func SaveTime() -> void:
	levelFinished = true
	game.times.append(minPassed * 60 + secondsPassed + milliPassed)


func _ready() -> void:
	game.worldChanged.connect(SetTimer)
	game.levelFinished.connect(SaveTime)


func _process(delta: float) -> void:
	if (levelFinished == true):
		return
	
	#TODO subscribe to signal and not do every process (maybe im too lazy)
	if (Global.game.timerEnabled != visible):
		set_deferred("visible", Global.game.timerEnabled)
	
	var formatedMilli : int = int(milliPassed * 100) % 100
	$Timer.text = str(minPassed).pad_zeros(2) + ":" + str(secondsPassed).pad_zeros(2) + ":" + str(formatedMilli).pad_zeros(2)
	
	milliPassed += delta
	
	if (milliPassed >= 1):
		milliPassed = 0
		secondsPassed += 1
	
	if (secondsPassed >= 60):
		secondsPassed = 0
		minPassed += 1
		
	game.currentTime = minPassed * 60 + secondsPassed + milliPassed
