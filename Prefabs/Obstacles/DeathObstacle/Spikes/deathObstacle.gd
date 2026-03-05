extends Node2D

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"

func _on_death_area_body_entered(body: Node2D) -> void:
	if(body.has_signal("kill")):
		body.kill.emit(causeOfDeath ,"Dead")
		await get_tree().process_frame


func _on_extend_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		animationPlayer.play("Extend")


func _on_extend_area_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		animationPlayer.play("Retract")
		
func GetNextPoint():
	pass
