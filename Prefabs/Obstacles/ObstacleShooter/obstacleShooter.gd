extends Node2D

@export var obstacleToShoot : PackedScene
@export var fireRate : float = 1
@export var delayOffsetTime : float
@export var speedOfObstacle : float = 200
@export var amountOfInstantiatedObjects : int = 5
@export var moveDirection : Vector2 = Vector2(0,-1)

var timer
var instantiatedObjects : Array

func _ready() -> void:
	timer = $Timer
	timer.wait_time = fireRate + delayOffsetTime
	
func _process(delta: float) -> void:
	if instantiatedObjects.size() > amountOfInstantiatedObjects:
		instantiatedObjects[0].queue_free()
		instantiatedObjects.remove_at(0)
		
	for child in instantiatedObjects.size():
		instantiatedObjects[child].position += moveDirection.normalized() * delta * speedOfObstacle
		
func _on_timer_timeout() -> void:
	var instance = obstacleToShoot.instantiate()
	add_sibling(instance)
	instance.position = position
	instantiatedObjects.append(instance)
