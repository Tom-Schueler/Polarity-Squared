extends Camera2D

@export var shakeStrength : float = 40
@export var shakeDuration : float = 1
@export var fadeOutTime : float = 2
@export var blackOut : bool = false

var startTime = 0
var _shakeStrength
var _shakeDuration
@onready var fadeOut = $FadeOut/ColorRect
@onready var fadeOutAnimation = $FadeOut/AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	#fadeOutAnimation.play("FadeIn")
	set_modulate(Color(1,1,1,1))

func InitiateFadeOut(time: float = fadeOutTime) -> void:
	var elapsed = 0.0
	
	while elapsed < time:
		var progress = elapsed / time
		fadeOut.set_modulate(Color(1, 1, 1, progress))
		elapsed += get_process_delta_time()
		await get_tree().process_frame
	
	fadeOutAnimation.play("FadeOut")
	
func InitiateCameraShake(duration: float = shakeDuration, strength: float = shakeStrength) -> void:
	if (not Global.game.screenshakeEnabled):
		return
		
	_shakeStrength = float(strength)
	_shakeDuration = float(duration)
	print(_shakeDuration)
	startTime = Time.get_ticks_msec()
	var elapsed = 0.0
	
	while elapsed < _shakeDuration:
		var progress = elapsed / _shakeDuration
		var a = 1 - progress
		var rand_x = rng.randf_range(-1, 1) * _shakeStrength * a
		var rand_y = rng.randf_range(-1, 1) * _shakeStrength * a
		offset = Vector2(rand_x, rand_y)
		elapsed += get_process_delta_time()
		await get_tree().process_frame
