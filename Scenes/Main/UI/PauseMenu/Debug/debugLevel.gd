extends VBoxContainer


@export var levelButton : PackedScene


var game : MainGame = Global.game


func _ready() -> void:
	if (not game.debugModeEnabled):
		return
	
	set_deferred("visible", true)
	
	for key : String in game.scenes.keys():
		var instance : Button = levelButton.instantiate()
		instance.level = key
		instance.text = key
		add_child(instance)
