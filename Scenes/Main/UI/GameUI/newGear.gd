extends Sprite2D

@export var rotation_speed: float = 20  # Adjust for desired speed

func _ready() -> void:
	rotation_degrees = 180

func _process(delta: float) -> void:
	var gravity_direction: Vector2 = PhysicsServer2D.area_get_param(
		get_viewport().find_world_2d().space,
		PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR
	).normalized()

	var target_angle = directionToDegrees(gravity_direction)
	rotation = lerp_angle(rotation, deg_to_rad(target_angle), rotation_speed * delta)

func directionToDegrees(direction: Vector2) -> float:
	if direction == Vector2.LEFT:
		return 270
	elif direction == Vector2.UP:
		return 0
	elif direction == Vector2.RIGHT:
		return 90
	else:
		return 180
