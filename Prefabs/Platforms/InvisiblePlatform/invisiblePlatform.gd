extends StaticBody2D

#TODO: Bad, refactor this script

@export var fadeInTime : float = .2
@export var visibilityDuration : float = 2
@export var fadeOutTime : float = 1

var timer
var fadeIn : bool = false
var sprite
var alpha : float
var player : Node2D

func _ready() -> void:
	set_process(false)
	timer = $Timer
	sprite = $Sprite2D
	sprite.modulate = Color(255,255,255,alpha)
	timer.wait_time = visibilityDuration
	alpha = 0

func _process(delta: float) -> void:
	if(fadeIn):
		alpha += delta / fadeInTime
		sprite.modulate = Color(255,255,255,alpha)
		if(alpha >= 1):
			timer.start()
			fadeIn = false
			set_process(false)
	elif(player == null):
		alpha -= delta / fadeOutTime
		sprite.modulate = Color(255,255,255,alpha)
		if(alpha <= 0):
			set_process(false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		fadeIn = true
		set_process(true)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	player = null

func _on_timer_timeout() -> void:
	set_process(true)
