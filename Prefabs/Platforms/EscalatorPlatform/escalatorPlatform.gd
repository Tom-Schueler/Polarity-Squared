extends Area2D

enum MoveDirection {NONE, LEFT, RIGHT}
@export var moveDirection: MoveDirection = MoveDirection.LEFT:
	set(value):
		OnDirectionChanged(value)
	get:
		return _moveDirection
@export var speed: float = 200
@export var forceQuitGravity : bool = false
@export var zeroGravity : bool = false

var _moveDirection: MoveDirection = MoveDirection.LEFT  # Initialize with default value
var boostDirection := Vector2.ZERO
var player : Node2D
var grav : float

func OnDirectionChanged(value: MoveDirection) -> void:
	_moveDirection = value
	
	match moveDirection:
		MoveDirection.NONE:
			boostDirection = Vector2.ZERO
		MoveDirection.LEFT:
			boostDirection = Vector2.LEFT
		MoveDirection.RIGHT:
			boostDirection = Vector2.RIGHT

func _ready() -> void:
	set_process(false)
	
func _process(delta: float) -> void:
	if player == null || not player.has_method("ExternalVelocity"): return
	
	player.ExternalVelocity(speed, boostDirection)
	if(forceQuitGravity):
		player.surfaceAlignment = player.SurfaceAlignment.DOWN

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		grav = player.gravity
		if(zeroGravity):
			player.gravity = 0
		set_process(true)
		print(player)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if(zeroGravity):
			player.gravity = grav
		player = null
		set_process(false)
		body.ExternalVelocity(0, Vector2.ZERO)
