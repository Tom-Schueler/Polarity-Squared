extends Sprite2D


## Deg. per second
@export var turningSpeed : int


func _process(delta: float) -> void:
	var gravityDirection : Vector2 = PhysicsServer2D.area_get_param(
			get_viewport().find_world_2d().space,
			PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR)
	gravityDirection = gravityDirection.normalized()
	
	var turningDirection : int
	if (gravityDirection == Vector2.DOWN || gravityDirection == Vector2.RIGHT):
		turningDirection = 1
	else:
		turningDirection = -1
	rotation_degrees += delta * turningSpeed * turningDirection
	
	if (rotation_degrees < 0):
		rotation_degrees = 360
	elif (rotation_degrees > 360):
		rotation_degrees = 0
