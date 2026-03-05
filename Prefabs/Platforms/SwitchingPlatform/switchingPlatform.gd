extends Node2D

@export_range(0, 1, 0.01, "or_greater") var reappearTimer : float
@export_range(0, 1, 0.01, "or_greater") var timeOffset : float
var toggle : bool

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	$Timer.wait_time = reappearTimer
	$Offset.wait_time = timeOffset + 0.01
	$Offset.start()
		
func ToggleAnimation() -> void:
	toggle = !toggle
	if(toggle):
		$Opener.play()
		animationPlayer.play("Open")
		$Opener.play()
	elif(!toggle):
		$Closer.play()
		animationPlayer.play("Close")
		$Closer.play()
	pass

func _on_timer_timeout() -> void:
	ToggleAnimation()

func _on_offset_timeout() -> void:
	$Timer.start()
	ToggleAnimation()
