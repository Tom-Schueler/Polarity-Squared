extends Area2D

enum Section {Section1, Section2, Section3}

@export_range(1, 1, 1, "or_greater") var checkpointIdentifier : int
@export var sprite : Node2D
@export var audioStreamPlayer : AudioStreamPlayer


func _PlayAnimation() -> void:
	if sprite:
		var animationPlayer : AnimationPlayer = sprite.get_child(sprite.get_child_count() - 1)
		animationPlayer.play("TurningOn")
		audioStreamPlayer.play()


func OnBodyEntered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_PlayAnimation()
		Global.game.currentCheckpointIdentifier = checkpointIdentifier
		Global.game.currentCheckpointPosition = position
		Global.game.timeAtCurrentCheckpoint = Global.game.currentTime
		set_deferred("monitoring", false)


func _ready() -> void:
	if Global.game.currentCheckpointIdentifier >= checkpointIdentifier:
		set_deferred("monitoring", false)
		_PlayAnimation()
