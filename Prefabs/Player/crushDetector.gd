extends Area2D


@export var player : CharacterBody2D
@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"

var crushingObjects : int


func OnBodyEntered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		return
	
	crushingObjects += 1
	
	if (crushingObjects >= 2):
		player.kill.emit(causeOfDeath ,"Dead")


func OnBodyExited(body: Node2D) -> void:
	crushingObjects -= 1


func _ready() -> void:
	if (Global.game.godModeEnabled == true):
		set_deferred("monitoring", false)
