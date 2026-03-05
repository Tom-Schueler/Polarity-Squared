extends Node2D


@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"
@export var audioStreamPlayer : AudioStreamPlayer2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_signal("kill")):
		body.kill.emit(causeOfDeath ,"Dead")
		await get_tree().process_frame
		
func GetNextPoint():
	pass
	

func _ready() -> void:
	await get_tree().create_timer(randf_range(0, 1)).timeout
	audioStreamPlayer.play()
