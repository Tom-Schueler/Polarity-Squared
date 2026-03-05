extends Area2D

signal obtainedKey

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		obtainedKey.emit()

func DeleteSelf():
	queue_free()
