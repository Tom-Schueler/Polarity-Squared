extends TabContainer


@export var audioStreamPlayer : AudioStreamPlayer


func TabClicked(tab: int) -> void:
	audioStreamPlayer.play()
	await  audioStreamPlayer.finished
