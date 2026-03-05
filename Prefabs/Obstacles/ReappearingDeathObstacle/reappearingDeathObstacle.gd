extends Node2D

@export var timeOffset : float = 0
@export var reappearTimer : float = 1
@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"
@export var audioStreamPlayerAppear : AudioStreamPlayer2D
@export var audioStreamPlayerDisapear : AudioStreamPlayer2D

var toggle : bool

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	$Timer.wait_time = reappearTimer
	$Offset.wait_time = timeOffset
	$Offset.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_signal("kill"):
		body.kill.emit(causeOfDeath, "Dead")

func ToggleAnimation() -> void:
	toggle = !toggle
	if(toggle):
		animationPlayer.play("Open")
		audioStreamPlayerDisapear.play()
	elif(!toggle):
		animationPlayer.play("Close")
		audioStreamPlayerAppear.play()


func _on_timer_timeout() -> void:
	ToggleAnimation()

func _on_offset_timeout() -> void:
	$Timer.start()
	ToggleAnimation()
