extends Node2D


@export var reappearTimer : float = 5
@export var oneShot : bool
@export var audioStreamPlayer : AudioStreamPlayer

var initial_y: float


func _ready() -> void:
	$Timer.wait_time = reappearTimer
	initial_y = position.y
	
func _process(delta: float) -> void:
	var new_y = initial_y + 10 * sin(2.5 * Time.get_ticks_msec() / 1000.0)
	position.y = new_y
	
func GetNextPoint() -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	#TODO: Check for function in player, and change stamina in a function of the player
	if body.is_in_group("Player"):
		audioStreamPlayer.play()
		body.currentStamina = body.gravityStamina

		if(oneShot):
			queue_free()
		
		set_deferred("visible", false)
		$Area2D.set_deferred("monitoring", false)
		$Timer.start()

func _on_timer_timeout() -> void:
	set_deferred("visible", true)
	$Area2D.set_deferred("monitoring", true)
