class_name Player extends CharacterBody2D


signal kill


enum SurfaceAlignment{DOWN, UP, LEFT, RIGHT}


@export_category("General Settings")
## How fast the player reaches top speed -> (Slidey)100---500(Snappy)
@export var acceleration : float
## Speed at which the player moves on the ground
@export var speed : float
## Jump height, duh
@export var jumpHeight : float
## Strength of Gravity
@export var gravity : float
## How fast the player can fall
@export var terminalVelocity : float
## How fast the player falls
@export var fallSpeedMultiplier : float
## How much the player can move in the air
@export_range(0, 1) var airControl : float
## After walking off a Ledge, the player has a small buffer to jump
@export var coyoteTime : float
## How long the player stays at peak jump height
@export_range(0.95, 1) var hangTime : float
@export var variableJumpHeight : float
@export_category("Stamina")
## The amount of Stamina the player has.
@export var gravityStamina : float
## The amount of Stamina it costs the player to change gravity
@export var gravityStaminaCost : float
## The amount the player loses per second
@export var staminaLoseRate : float
## How faar the player is alowed to aditionly fall after jumping befor losing stamina
@export var jumpMargin : float
@export_category("Misc")
@export var surfaceAlignment : SurfaceAlignment = SurfaceAlignment.DOWN :
	set(value):
		SetSurfaceAlignment(value)
	get:
		return _surfaceAlignment

##In Seconds
@export var timeUntilDance : float
@export var cast : ShapeCast2D

@onready var coyoteTimer : Timer = $CoyoteTimer
@onready var savedGravity = gravity
@onready var playerSprite = $Animation


var currentStamina : float = 0.0
var _surfaceAlignment : SurfaceAlignment
var gravitationVector : Vector2
var isJumping : bool = false
var positionOfJumpInitiation : Vector2
var lastMovementVelocity : Vector2
var lastGravityVelocity : Vector2
var directionalVelocity : Vector2 = Vector2.ZERO
var gravityChanged : bool = false
var wasOnFloor : bool

var movementInput : Vector2 = Vector2.ZERO
var jumpInput : bool
var gravityInput : Vector2 = Vector2.DOWN

var camera : Camera2D


# change the gravitation and tell the character body where is up
func SetSurfaceAlignment(value : SurfaceAlignment) -> void:
	if (_surfaceAlignment == value):
		return
	
	_surfaceAlignment = value
	gravityChanged = true
	
	if (Global.game.infinateStaminaEnabled == false):
		currentStamina -= gravityStaminaCost
		#var animationPlayer : AnimationPlayer = playerSprite.find_child("AnimationPlayer")
		#animationPlayer.play("Gravity Switch")
		#await animationPlayer.animation_finished
		
	match surfaceAlignment:
		SurfaceAlignment.DOWN:
			ChangeGravityVector(Vector2.DOWN)
			up_direction = -Vector2.DOWN
			rotation_degrees = 0
			
		SurfaceAlignment.UP:
			ChangeGravityVector(Vector2.UP)
			up_direction = -Vector2.UP
			rotation_degrees = 180
			
		SurfaceAlignment.LEFT:
			ChangeGravityVector(Vector2.LEFT)
			up_direction = -Vector2.LEFT
			rotation_degrees = 90
			
		SurfaceAlignment.RIGHT:
			ChangeGravityVector(Vector2.RIGHT)
			up_direction = -Vector2.RIGHT
			rotation_degrees = 270


func ChangeGravityVector(vector : Vector2) -> void:
	if (get_viewport()):
		PhysicsServer2D.area_set_param(
					get_viewport().find_world_2d().space,
					PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR,
					vector)
		
		gravitationVector = vector
		
		print("Gravety changed to: " + str(get_gravity()))
	else:
		print("No viewport found. Surfacealignment could not be changed.")
	
func MoveOnCurrentFloorAxis(delta) -> void:
	var flip = movementInput.ceil() * gravitationVector.orthogonal().abs()
	match surfaceAlignment:
		SurfaceAlignment.UP:
			playerSprite.scale.x = playerSprite.scale.x if flip.x == 0 else -flip.x
		SurfaceAlignment.DOWN:
			playerSprite.scale.x = playerSprite.scale.x if flip.x == 0 else flip.x
		SurfaceAlignment.LEFT:
			playerSprite.scale.x = playerSprite.scale.x if flip.y == 0 else flip.y
		SurfaceAlignment.RIGHT:
			playerSprite.scale.x = playerSprite.scale.x if flip.y == 0 else -flip.y
	
	var currentAcceleration = acceleration
	if(not is_on_floor()):
		currentAcceleration *= airControl
	
	var targetVelocity = gravitationVector.abs() * velocity + gravitationVector.orthogonal().abs() * movementInput * speed + directionalVelocity
	velocity = velocity.move_toward(targetVelocity, currentAcceleration * delta)


func ExternalVelocity(speedValue : float, direction : Vector2) -> void:
	directionalVelocity = gravitationVector.orthogonal().abs() * direction * speedValue


func ApplyGravity(delta) -> void:
	velocity += GetGravity(gravity) * delta
	if ((velocity * gravitationVector).length() > terminalVelocity):
		velocity = velocity * gravitationVector.orthogonal().abs() + gravitationVector * terminalVelocity

# TODO why not use godots build in get_gravity()
func GetGravity(value) -> Vector2:
	return gravitationVector * value


func _GetRespectiveHeight(vector : Vector2) -> float:
	var height : Vector2 = vector * gravitationVector
	return height.x + height.y


func _AbovePositionOfJumpinitiation() -> bool:
	return _GetRespectiveHeight(positionOfJumpInitiation) + jumpMargin < _GetRespectiveHeight(position)


func _SetGravityStamina(delta : float) -> void:
	if (Global.game.infinateStaminaEnabled == true):
		return
	
	if (not is_on_floor()):
		# if player is not jumping or player position is "below", respective to the current 
		# gravity dicection, the hight it was when he initiated the jump, -> lower stamina 
		# (isJumping is only the upward direction of the whole jump process)
		if (gravityChanged == true || (not isJumping && _AbovePositionOfJumpinitiation())):
			currentStamina -= staminaLoseRate * delta
	elif (not wasOnFloor):
		gravityChanged = false
		
		if (surfaceAlignment == SurfaceAlignment.DOWN):
			currentStamina = gravityStamina
		
	if (currentStamina <= 0 && surfaceAlignment != SurfaceAlignment.DOWN):
		gravityInput = Vector2.DOWN
		surfaceAlignment = SurfaceAlignment.DOWN
	
	if (wasOnFloor && !is_on_floor()):
		positionOfJumpInitiation = position
	
	wasOnFloor = is_on_floor()


func _physics_process(delta: float) -> void:
	movementInput = (Input.get_vector("Left", "Right", "Up", "Down") * gravitationVector.orthogonal().abs()).round()
	
	jumpInput = Input.is_action_just_pressed("Jump")
	
	if(currentStamina <= 0):
		gravityInput = Vector2.DOWN
	else:
		if Input.is_action_just_pressed("GravityDown"):
			gravityInput = Vector2.DOWN
		elif Input.is_action_just_pressed("GravityLeft"):
			gravityInput = Vector2.LEFT
		elif Input.is_action_just_pressed("GravityRight"):
			gravityInput = Vector2.RIGHT
		elif Input.is_action_just_pressed("GravityUp"):
			gravityInput = Vector2.UP
	
	_SetGravityStamina(delta)
	
	var movingPlatformReference : Node2D = null
	if (cast.is_colliding() && cast.get_collider(0) != null):
		if (cast.get_collider(0).is_in_group("MovingPlatform")):
			movingPlatformReference = cast.get_collider(0)
			movingPlatformReference.childObject = self

	if (movingPlatformReference != null):
		movingPlatformReference.MovePlayerWithObject()
		movingPlatformReference.childObject = null


func _ready() -> void:
	gravitationVector = Vector2.DOWN
	
	#TODO ?
	surfaceAlignment = surfaceAlignment 
	currentStamina = gravityStamina
	lastGravityVelocity = velocity
	
	if (Global.game.currentCheckpointIdentifier != 0):
		position = Global.game.currentCheckpointPosition
		
	if (Global.game.godModeEnabled == true):
		set_collision_layer_value(2, false)
